extends CanvasLayer

signal continuar_solicitado
signal menu_principal_solicitado

const RUTA_BOTON_CONTINUAR: String = "res://assets/final/btncontinuar.png"
const RUTA_BOTON_MENU: String = "res://assets/final/btnmenu.png"

@onready var boton_continuar: BaseButton = $BotonContinuar
@onready var boton_menu_principal: BaseButton = $BotonMenuPrincipal


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10

	configurar_boton(
		boton_continuar,
		RUTA_BOTON_CONTINUAR
	)

	configurar_boton(
		boton_menu_principal,
		RUTA_BOTON_MENU
	)

	boton_continuar.pressed.connect(_on_boton_continuar_pressed)
	boton_menu_principal.pressed.connect(_on_boton_menu_principal_pressed)


func configurar_boton(boton: BaseButton, ruta: String) -> void:
	var textura: Texture2D = load(ruta) as Texture2D

	if textura == null:
		push_error("No se pudo cargar la imagen: " + ruta)
		return

	boton.visible = true

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


func _on_boton_continuar_pressed() -> void:
	continuar_solicitado.emit()


func _on_boton_menu_principal_pressed() -> void:
	menu_principal_solicitado.emit()
