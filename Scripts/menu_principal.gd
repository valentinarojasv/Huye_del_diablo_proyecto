extends Control

const ESCENA_JUEGO: String = "res://Scenes/game/juego.tscn"


func _ready() -> void:
	pass


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file(ESCENA_JUEGO)
