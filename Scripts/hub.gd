extends Control

@onready var barra_turbo: ProgressBar = $BarraTurbo
@onready var indicador_tiempo: Label = $PanelTiempo/IndicadorTiempo

@onready var corazon1: TextureRect = $ContenedorCorazones/Corazon1
@onready var corazon2: TextureRect = $ContenedorCorazones/Corazon2
@onready var corazon3: TextureRect = $ContenedorCorazones/Corazon3

@onready var textura_corazon_rojo: Texture2D = corazon1.texture
@onready var textura_corazon_gris: Texture2D = preload("res://assets/final/corazon.png")


func _ready() -> void:
	# HUB ahora esta dentro de ControlesMoviles.
	# Subimos dos niveles para encontrar Juego.
	var juego: Node2D = get_parent().get_parent() as Node2D

	# Jugador sigue siendo hijo directo de Juego.
	var jugador: CharacterBody2D = juego.get_node("Jugador") as CharacterBody2D

	# Conectar la energia del Turbo.
	jugador.energia_turbo_cambiada.connect(
		_actualizar_barra_turbo
	)

	# Conectar las vidas del jugador.
	jugador.vidas_cambiadas.connect(
		_actualizar_vidas
	)

	# Mostrar la energia inicial.
	if jugador.configuracion != null:
		_actualizar_barra_turbo(
			jugador.energia_turbo,
			jugador.configuracion.energia_maxima
		)

	# Mostrar las vidas iniciales.
	_actualizar_vidas(jugador.vidas_actuales)

	# Conectar el cronometro.
	juego.tiempo_actualizado.connect(_actualizar_tiempo)

	# Mostrar el tiempo inicial.
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
