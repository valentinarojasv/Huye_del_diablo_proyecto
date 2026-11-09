extends CharacterBody2D

@export var configuracion: ConfiguracionJugador

signal energia_turbo_cambiada(energia_actual: float, energia_maxima: float)
signal vidas_cambiadas(vidas_actuales: int)
signal jugador_derrotado
signal dano_recibido

@onready var sprite: Sprite2D = $Sprite2D

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

const INTERVALO_PARPADEO: float = 0.1
var tiempo_parpadeo: float = 0.0


func _ready() -> void:
	if configuracion == null:
		push_error("Jugador: falta asignar ConfiguracionJugador.")
		set_physics_process(false)
		return

	energia_turbo = configuracion.energia_maxima
	vidas_actuales = configuracion.vidas_iniciales

	sprite.visible = true

	energia_turbo_cambiada.emit(
		energia_turbo,
		configuracion.energia_maxima
	)

	vidas_cambiadas.emit(vidas_actuales)


func _physics_process(delta: float) -> void:
	actualizar_invulnerabilidad(delta)
	actualizar_turbo(delta)
	actualizar_movimiento()


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

	GestorAudio.reproducir_sonido("latigazo")

	if vidas_actuales <= 0:
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
