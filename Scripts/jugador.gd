extends CharacterBody2D

@export var configuracion: ConfiguracionJugador

signal energia_turbo_cambiada(energia_actual: float, energia_maxima: float)
signal vidas_cambiadas(vidas_actuales: int)
signal jugador_derrotado
signal dano_recibido

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var polvo_correr: GPUParticles2D = $PolvoCorrer
@onready var estela_turbo: GPUParticles2D = $EstelaTurbo

var energia_turbo: float = 100.0
var turbo_activo: bool = false
var turbo_bloqueado: bool = false
var tiempo_sin_turbo: float = 0.0

# Estado del boton tactil de turbo.
var turbo_tactil_presionado: bool = false

var vidas_actuales: int = 3
var invulnerable: bool = false
var tiempo_invulnerabilidad: float = 0.0

# Direccion recibida desde el joystick virtual.
var direccion_joystick: Vector2 = Vector2.ZERO

# Ultima direccion hacia la que mira el campesino.
var ultima_animacion: StringName = &"caminar_abajo"

const INTERVALO_PARPADEO: float = 0.1
const VELOCIDAD_MINIMA_POLVO: float = 10.0

var tiempo_parpadeo: float = 0.0


func _ready() -> void:
	if configuracion == null:
		push_error("Jugador: falta asignar ConfiguracionJugador.")
		set_physics_process(false)
		return

	energia_turbo = configuracion.energia_maxima
	vidas_actuales = configuracion.vidas_iniciales

	sprite.visible = true

	# Mostrar al campesino mirando hacia abajo al iniciar.
	sprite.play(ultima_animacion)
	sprite.stop()
	sprite.frame = 0

	# Los efectos comienzan desactivados.
	polvo_correr.emitting = false
	estela_turbo.emitting = false

	# El sonido de pasos comienza detenido.
	GestorAudio.detener_pasos()

	energia_turbo_cambiada.emit(
		energia_turbo,
		configuracion.energia_maxima
	)

	vidas_cambiadas.emit(vidas_actuales)


func _physics_process(delta: float) -> void:
	actualizar_invulnerabilidad(delta)
	actualizar_turbo(delta)
	actualizar_movimiento()
	actualizar_animacion()
	actualizar_polvo()
	actualizar_estela_turbo()
	actualizar_sonido_pasos()


# ==========================================
# INVULNERABILIDAD
# ==========================================

func actualizar_invulnerabilidad(delta: float) -> void:
	if not invulnerable:
		return

	tiempo_invulnerabilidad -= delta
	tiempo_parpadeo -= delta

	if tiempo_parpadeo <= 0.0:
		sprite.visible = not sprite.visible
		tiempo_parpadeo = INTERVALO_PARPADEO

	if tiempo_invulnerabilidad <= 0.0:
		tiempo_invulnerabilidad = 0.0
		invulnerable = false
		sprite.visible = true


# ==========================================
# SISTEMA DE TURBO
# ==========================================

func actualizar_turbo(delta: float) -> void:
	var energia_anterior: float = energia_turbo

	# Permitir activar el turbo con teclado o boton tactil.
	var turbo_presionado: bool = (
		Input.is_action_pressed("turbo")
		or turbo_tactil_presionado
	)

	turbo_activo = (
		turbo_presionado
		and not turbo_bloqueado
		and energia_turbo > 0.0
	)

	if turbo_activo:
		energia_turbo -= configuracion.consumo_turbo * delta
		energia_turbo = maxf(energia_turbo, 0.0)
		tiempo_sin_turbo = 0.0

		if energia_turbo <= 0.0:
			energia_turbo = 0.0
			turbo_activo = false
			turbo_bloqueado = true

	else:
		tiempo_sin_turbo += delta

		if tiempo_sin_turbo >= configuracion.retraso_regeneracion:
			energia_turbo += configuracion.regeneracion_turbo * delta
			energia_turbo = minf(
				energia_turbo,
				configuracion.energia_maxima
			)

		if (
			turbo_bloqueado
			and energia_turbo >= configuracion.energia_minima_reactivacion
		):
			turbo_bloqueado = false

	if not is_equal_approx(energia_anterior, energia_turbo):
		energia_turbo_cambiada.emit(
			energia_turbo,
			configuracion.energia_maxima
		)


# ==========================================
# CONTROL DEL TURBO TACTIL
# ==========================================

func establecer_turbo_tactil(presionado: bool) -> void:
	turbo_tactil_presionado = presionado


# ==========================================
# MOVIMIENTO DEL JUGADOR
# ==========================================

func actualizar_movimiento() -> void:
	# Movimiento mediante teclado.
	var direccion_teclado: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	var direccion: Vector2 = direccion_teclado

	# Utilizar el joystick cuando no se presiona el teclado.
	if direccion_teclado == Vector2.ZERO:
		direccion = direccion_joystick

	# Evitar que el movimiento diagonal supere la velocidad maxima.
	direccion = direccion.limit_length(1.0)

	var velocidad_actual: float = configuracion.velocidad_normal

	if turbo_activo:
		velocidad_actual = configuracion.velocidad_turbo

	velocity = direccion * velocidad_actual

	move_and_slide()


# ==========================================
# ANIMACIONES DEL CAMPESINO
# ==========================================

func actualizar_animacion() -> void:
	# Obtener el movimiento real del personaje.
	var direccion: Vector2 = get_real_velocity()

	# Detener la animacion cuando el campesino esta quieto.
	if direccion.length() <= VELOCIDAD_MINIMA_POLVO:
		sprite.stop()
		return

	var nueva_animacion: StringName

	# Seleccionar una de las cuatro direcciones.
	if absf(direccion.x) > absf(direccion.y):
		if direccion.x > 0.0:
			nueva_animacion = &"caminar_derecha"
		else:
			nueva_animacion = &"caminar_izquierda"
	else:
		if direccion.y > 0.0:
			nueva_animacion = &"caminar_abajo"
		else:
			nueva_animacion = &"caminar_arriba"

	# Cambiar de animacion solamente cuando cambia la direccion.
	if nueva_animacion != ultima_animacion:
		ultima_animacion = nueva_animacion
		sprite.play(ultima_animacion)

	# Reanudar la animacion al volver a caminar.
	elif not sprite.is_playing():
		sprite.play(ultima_animacion)


# ==========================================
# EFECTO DE POLVO AL CORRER
# ==========================================

func actualizar_polvo() -> void:
	# Utilizar la velocidad real despues de las colisiones.
	var velocidad_real: Vector2 = get_real_velocity()

	var jugador_moviendo: bool = (
		velocidad_real.length() > VELOCIDAD_MINIMA_POLVO
	)

	# Emitir polvo solamente cuando el jugador se desplaza.
	polvo_correr.emitting = jugador_moviendo


# ==========================================
# ESTELA DE VELOCIDAD DEL TURBO
# ==========================================

func actualizar_estela_turbo() -> void:
	# Comprobar que el jugador realmente se este moviendo.
	var velocidad_real: Vector2 = get_real_velocity()

	var jugador_moviendo: bool = (
		velocidad_real.length() > VELOCIDAD_MINIMA_POLVO
	)

	# La estela aparece solamente durante el turbo.
	estela_turbo.emitting = (
		turbo_activo
		and jugador_moviendo
	)


# ==========================================
# SONIDO DE PASOS DEL JUGADOR
# ==========================================

func actualizar_sonido_pasos() -> void:
	# Obtener la velocidad real despues de las colisiones.
	var velocidad_real: Vector2 = get_real_velocity()

	var jugador_moviendo: bool = (
		velocidad_real.length() > VELOCIDAD_MINIMA_POLVO
	)

	if jugador_moviendo:
		# GestorAudio evita reiniciar el sonido
		# cuando ya se esta reproduciendo.
		GestorAudio.reproducir_pasos()
	else:
		# Detener los pasos cuando el jugador se detiene.
		GestorAudio.detener_pasos()


# ==========================================
# CONTROL DEL JOYSTICK VIRTUAL
# ==========================================

func establecer_direccion_joystick(nueva_direccion: Vector2) -> void:
	direccion_joystick = nueva_direccion.limit_length(1.0)


# ==========================================
# SISTEMA DE DAÑO
# ==========================================

func recibir_dano() -> void:
	if invulnerable or vidas_actuales <= 0:
		return

	vidas_actuales -= 1

	vidas_cambiadas.emit(vidas_actuales)

	dano_recibido.emit()

	# Reproducir el impacto solamente cuando
	# el jugador recibe un golpe y pierde una vida.
	GestorAudio.reproducir_sonido("impacto")

	if vidas_actuales <= 0:
		polvo_correr.emitting = false
		estela_turbo.emitting = false

		# Detener los pasos al perder todas las vidas.
		GestorAudio.detener_pasos()

		jugador_derrotado.emit()
		return

	invulnerable = true
	tiempo_invulnerabilidad = configuracion.duracion_invulnerabilidad
	tiempo_parpadeo = 0.0


# ==========================================
# SEÑAL DEL JOYSTICK VIRTUAL
# ==========================================

func _on_joystick_virtual_direccion_cambiada(direccion: Vector2) -> void:
	establecer_direccion_joystick(direccion)
