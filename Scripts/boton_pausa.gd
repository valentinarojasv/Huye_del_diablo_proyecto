extends TextureButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_boton_pausa_pressed)


func _on_boton_pausa_pressed() -> void:
	get_tree().paused = not get_tree().paused


func _exit_tree() -> void:
	if get_tree().paused:
		get_tree().paused = false
