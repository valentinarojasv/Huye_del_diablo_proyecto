extends Control

@onready var barra_turbo: ProgressBar = $BarraTurbo
@onready var indicador_tiempo: Label = $PanelTiempo/IndicadorTiempo

@onready var corazon1: TextureRect = $ContenedorCorazones/Corazon1
@onready var corazon2: TextureRect = $ContenedorCorazones/Corazon2
@onready var corazon3: TextureRect = $ContenedorCorazones/Corazon3

@onready var textura_corazon_rojo: Texture2D = corazon1.texture
@onready var textura_corazon_gris: Texture2D = preload("res://assets/final/corazon.png")


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
	corazon1.texture = textura_corazon_rojo if vidas_actuales >= 1 else textura_corazon_gris
	corazon2.texture = textura_corazon_rojo if vidas_actuales >= 2 else textura_corazon_gris
	corazon3.texture = textura_corazon_rojo if vidas_actuales >= 3 else textura_corazon_gris


func _actualizar_tiempo(segundos: int) -> void:
	indicador_tiempo.text = "TIEMPO: %d S" % segundos
