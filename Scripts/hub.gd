extends Control

@onready var barra_turbo: ProgressBar = $BarraTurbo
@onready var indicador_vidas: Label = $IndicadorVidas
@onready var indicador_tiempo: Label = $IndicadorTiempo


func _ready() -> void:
	var juego: Node2D = get_parent()
	var jugador: CharacterBody2D = juego.get_node("Jugador")

	jugador.energia_turbo_cambiada.connect(
		_actualizar_barra_turbo
	)

	jugador.vidas_cambiadas.connect(
		_actualizar_vidas
	)

	if jugador.configuracion != null:
		_actualizar_barra_turbo(
			jugador.energia_turbo,
			jugador.configuracion.energia_maxima
		)

	_actualizar_vidas(jugador.vidas_actuales)

	juego.tiempo_actualizado.connect(_actualizar_tiempo)
	_actualizar_tiempo(juego.tiempo_supervivencia)


func _actualizar_barra_turbo(
	energia_actual: float,
	energia_maxima: float
) -> void:
	barra_turbo.max_value = energia_maxima
	barra_turbo.value = energia_actual


func _actualizar_vidas(vidas_actuales: int) -> void:
	indicador_vidas.text = "VIDAS: %d" % vidas_actuales


func _actualizar_tiempo(segundos: int) -> void:
	indicador_tiempo.text = "TIEMPO: %d S" % segundos
