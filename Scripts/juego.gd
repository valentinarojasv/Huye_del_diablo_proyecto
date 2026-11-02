extends Node2D

signal tiempo_actualizado(segundos: int)

@onready var cronometro: Timer = $Cronometro
@onready var jugador: CharacterBody2D = $Jugador
@onready var diablo: CharacterBody2D = $Diablo
@onready var destello_rojo: ColorRect = $EfectosPantalla/DestelloRojo
@onready var camara_jugador: Camera2D = $Jugador/CamaraJugador
@onready var fin_juego: Control = $FinJuego

var tiempo_supervivencia: int = 0
var partida_terminada: bool = false

var animacion_destello: Tween
var animacion_sacudida: Tween

const INTENSIDAD_SACUDIDA: float = 8.0
const DURACION_SACUDIDA: float = 0.20


func _ready() -> void:
	tiempo_supervivencia = 0
	partida_terminada = false

	fin_juego.visible = false

	cronometro.timeout.connect(_on_cronometro_timeout)
	jugador.dano_recibido.connect(_on_jugador_dano_recibido)
	jugador.jugador_derrotado.connect(_on_jugador_derrotado)

	tiempo_actualizado.emit(tiempo_supervivencia)


func _on_cronometro_timeout() -> void:
	if partida_terminada:
		return

	tiempo_supervivencia += 1
	tiempo_actualizado.emit(tiempo_supervivencia)


func _on_jugador_dano_recibido() -> void:
	activar_destello_rojo()
	activar_sacudida_camara()


func _on_jugador_derrotado() -> void:
	if partida_terminada:
		return

	partida_terminada = true

	# Detener el cronómetro.
	cronometro.stop()

	# Detener al jugador y al diablo.
	jugador.set_physics_process(false)
	diablo.set_physics_process(false)

	jugador.velocity = Vector2.ZERO
	diablo.velocity = Vector2.ZERO

	# Mostrar Game Over con el tiempo real de supervivencia.
	fin_juego.mostrar_tiempo(tiempo_supervivencia)
	fin_juego.visible = true


func activar_destello_rojo() -> void:
	if animacion_destello != null:
		if animacion_destello.is_running():
			animacion_destello.kill()

	destello_rojo.visible = true
	destello_rojo.modulate.a = 1.0

	animacion_destello = create_tween()

	animacion_destello.tween_property(
		destello_rojo,
		"modulate:a",
		0.0,
		0.25
	)

	animacion_destello.tween_callback(
		func() -> void:
			destello_rojo.visible = false
	)


func activar_sacudida_camara() -> void:
	if animacion_sacudida != null:
		if animacion_sacudida.is_running():
			animacion_sacudida.kill()

	camara_jugador.offset = Vector2.ZERO

	animacion_sacudida = create_tween()

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2(INTENSIDAD_SACUDIDA, -INTENSIDAD_SACUDIDA),
		DURACION_SACUDIDA / 4.0
	)

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2(-INTENSIDAD_SACUDIDA, INTENSIDAD_SACUDIDA),
		DURACION_SACUDIDA / 4.0
	)

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2(INTENSIDAD_SACUDIDA / 2.0, 0.0),
		DURACION_SACUDIDA / 4.0
	)

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2.ZERO,
		DURACION_SACUDIDA / 4.0
	)
