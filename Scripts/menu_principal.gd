extends Control

const ESCENA_JUEGO: String = "res://Scenes/game/juego.tscn"

@onready var mejor_puntaje: Label = $MejorPuntaje


func _ready() -> void:
	actualizar_record()

	# En el menu principal solo debe sonar game.ogg.
	GestorAudio.reproducir_musica_menu()


func actualizar_record() -> void:
	var record: int = GestorRecords.obtener_record()
	mejor_puntaje.text = "MEJOR TIEMPO: %d S" % record


# ==========================================
# AUDIO EN NAVEGADORES
# ==========================================

func _input(event: InputEvent) -> void:
	if not OS.has_feature("web"):
		return

	if event is InputEventMouseButton:
		if event.pressed:
			iniciar_musica_menu()

	elif event is InputEventScreenTouch:
		if event.pressed:
			iniciar_musica_menu()

	elif event is InputEventKey:
		if event.pressed and not event.echo:
			iniciar_musica_menu()


func iniciar_musica_menu() -> void:
	if GestorAudio.ruta_musica_actual != GestorAudio.MUSICA_MENU:
		GestorAudio.reproducir_musica_menu()
		return

	if not GestorAudio.reproductor_musica.playing:
		GestorAudio.reproducir_musica_menu()


# ==========================================
# BOTON JUGAR
# ==========================================

func _on_boton_jugar_pressed() -> void:
	# La musica de juego comienza al entrar a la partida.
	var error: Error = get_tree().change_scene_to_file(ESCENA_JUEGO)

	if error != OK:
		push_error("No se pudo cargar la partida.")
