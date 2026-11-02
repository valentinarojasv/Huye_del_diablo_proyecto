extends Control

@onready var tiempo_supervivencia: Label = $TiempoSupervivencia


func mostrar_tiempo(segundos: int) -> void:
	tiempo_supervivencia.text = "TIEMPO SOBREVIVIDO: %d S" % segundos
