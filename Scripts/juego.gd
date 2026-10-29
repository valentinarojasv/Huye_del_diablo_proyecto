extends Node2D

signal tiempo_actualizado(segundos: int)

@onready var cronometro: Timer = $Cronometro

var tiempo_supervivencia: int = 0


func _ready() -> void:
	tiempo_supervivencia = 0

	cronometro.timeout.connect(_on_cronometro_timeout)

	tiempo_actualizado.emit(tiempo_supervivencia)


func _on_cronometro_timeout() -> void:
	tiempo_supervivencia += 1

	tiempo_actualizado.emit(tiempo_supervivencia)
