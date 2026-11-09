extends Control

const ESCENA_JUEGO: String = "res://Scenes/game/juego.tscn"
const MUSICA_MENU: String = "res://audio/intro.ogg"

@onready var mejor_puntaje: Label = $MejorPuntaje

var musica_iniciada: bool = false


func _ready() -> void:
	actualizar_record()


func actualizar_record() -> void:
	var record: int = GestorRecords.obtener_record()

	mejor_puntaje.text = "MEJOR TIEMPO: %d S" % record


# MUSICA DEL MENU PRINCIPAL

func _input(event: InputEvent) -> void:
	if musica_iniciada:
		return

	if event is InputEventMouseButton:
		var clic: InputEventMouseButton = event

		if clic.pressed:
			iniciar_musica()

	elif event is InputEventScreenTouch:
		var toque: InputEventScreenTouch = event

		if toque.pressed:
			iniciar_musica()

	elif event is InputEventKey:
		var tecla: InputEventKey = event

		if tecla.pressed and not tecla.echo:
			iniciar_musica()


func iniciar_musica() -> void:
	if musica_iniciada:
		return

	musica_iniciada = true
	GestorAudio.reproducir_musica(MUSICA_MENU)


# BOTON JUGAR

func _on_boton_jugar_pressed() -> void:
	GestorAudio.detener_musica()

	get_tree().change_scene_to_file(ESCENA_JUEGO)
