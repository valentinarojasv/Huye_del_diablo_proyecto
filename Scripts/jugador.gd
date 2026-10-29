extends CharacterBody2D

@export var configuracion: ConfiguracionJugador

signal energia_turbo_cambiada(energia_actual: float, energia_maxima: float)

var energia_turbo: float = 100.0
var turbo_activo: bool = false
var turbo_bloqueado: bool = false
var tiempo_sin_turbo: float = 0.0


func _ready() -> void:
	if configuracion == null:
		push_error("Jugador: falta asignar ConfiguracionJugador.")
		set_physics_process(false)
		return

	energia_turbo = configuracion.energia_maxima
	energia_turbo_cambiada.emit(
		energia_turbo,
		configuracion.energia_maxima
	)


func _physics_process(delta: float) -> void:
	actualizar_turbo(delta)
	actualizar_movimiento()


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
