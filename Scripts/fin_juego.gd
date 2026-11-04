extends CanvasLayer

signal reintentar_solicitado
signal menu_principal_solicitado

const RUTA_FONDO: String = "res://assets/final/Gameovermenu.png"
const RUTA_BOTON_REINTENTAR: String = "res://assets/final/btnreintentar.png"
const RUTA_BOTON_MENU: String = "res://assets/final/btnprincipal.png"

@onready var fondo_game_over: TextureRect = $FondoGameOver
@onready var titulo_game_over: TextureRect = $TituloGameOver
@onready var tiempo_supervivencia: Label = $TiempoSupervivencia
@onready var mejor_puntuacion: Label = $MejorPuntuacion

@onready var boton_reintentar: BaseButton = $Botonreintentar
@onready var boton_menu: BaseButton = $Botonmenu


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10

	configurar_fondo()

	configurar_boton(
		boton_reintentar,
		RUTA_BOTON_REINTENTAR
	)

	configurar_boton(
		boton_menu,
		RUTA_BOTON_MENU
	)

	boton_reintentar.pressed.connect(_on_boton_reintentar_pressed)
	boton_menu.pressed.connect(_on_boton_menu_pressed)

	actualizar_mejor_puntuacion()


func configurar_fondo() -> void:
	var textura: Texture2D = load(RUTA_FONDO) as Texture2D

	if textura == null:
		push_error("No se pudo cargar el fondo de Game Over.")
		return

	fondo_game_over.texture = textura
	fondo_game_over.visible = true

	fondo_game_over.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	fondo_game_over.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fondo_game_over.stretch_mode = TextureRect.STRETCH_SCALE

	fondo_game_over.z_index = 0
	titulo_game_over.z_index = 1
	tiempo_supervivencia.z_index = 2
	mejor_puntuacion.z_index = 2


func configurar_boton(boton: BaseButton, ruta: String) -> void:
	var textura: Texture2D = load(ruta) as Texture2D

	if textura == null:
		push_error("No se pudo cargar la imagen: " + ruta)
		return

	boton.visible = true
	boton.z_index = 3

	if boton is TextureButton:
		var boton_textura: TextureButton = boton as TextureButton

		boton_textura.texture_normal = textura
		boton_textura.ignore_texture_size = true
		boton_textura.stretch_mode = TextureButton.STRETCH_SCALE

	elif boton is Button:
		var boton_normal: Button = boton as Button

		boton_normal.text = ""
		boton_normal.icon = textura
		boton_normal.expand_icon = true


func mostrar_tiempo(segundos: int) -> void:
	tiempo_supervivencia.text = "TIEMPO SOBREVIVIDO: %d S" % segundos
	actualizar_mejor_puntuacion()


func actualizar_mejor_puntuacion() -> void:
	var record: int = GestorRecords.obtener_record()

	mejor_puntuacion.text = "MEJOR TIEMPO: %d S" % record


func _on_boton_reintentar_pressed() -> void:
	reintentar_solicitado.emit()


func _on_boton_menu_pressed() -> void:
	menu_principal_solicitado.emit()
