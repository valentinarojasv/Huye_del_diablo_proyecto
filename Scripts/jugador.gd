extends CharacterBody2D

@export var configuracion: ConfiguracionJugador

signal energia_turbo_cambiada(energia_actual: float, energia_maxima: float)
signal vidas_cambiadas(vidas_actuales: int)
signal jugador_derrotado

@onready var sprite: Sprite2D = $Sprite2D

var energia_turbo: float = 100.0
var turbo_activo: bool = false
var turbo_bloqueado: bool = false
var tiempo_sin_turbo: float = 0.0

var vidas_actuales: int = 3
var invulnerable: bool = false
var tiempo_invulnerabilidad: float = 0.0

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


func actualizar_turbo(delta: float) -> void:
	var energia_anterior: float = energia_turbo
	var turbo_presionado: bool = Input.is_action_pressed("turbo")

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


func actualizar_movimiento() -> void:
	var direccion: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	var velocidad_actual: float = configuracion.velocidad_normal

	if turbo_activo:
		velocidad_actual = configuracion.velocidad_turbo

	velocity = direccion * velocidad_actual

	move_and_slide()


func recibir_dano() -> void:
	if invulnerable or vidas_actuales <= 0:
		return

	vidas_actuales -= 1
	vidas_cambiadas.emit(vidas_actuales)

	if vidas_actuales <= 0:
		jugador_derrotado.emit()
		return

	invulnerable = true
	tiempo_invulnerabilidad = configuracion.duracion_invulnerabilidad
	tiempo_parpadeo = 0.0
