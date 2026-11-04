extends Control

const ESCENA_JUEGO: String = "res://Scenes/game/juego.tscn"

@onready var mejor_puntaje: Label = $MejorPuntaje


func _ready() -> void:
	actualizar_record()


func actualizar_record() -> void:
	var record: int = GestorRecords.obtener_record()

	mejor_puntaje.text = "MEJOR TIEMPO: %d S" % record


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file(ESCENA_JUEGO)
