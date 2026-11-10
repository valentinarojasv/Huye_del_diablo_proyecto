extends Control

signal direccion_cambiada(direccion: Vector2)

@export_range(0.0, 1.0, 0.01) var zona_muerta: float = 0.2

@onready var base: Panel = $Base
@onready var perilla: Panel = $Perilla

var direccion: Vector2 = Vector2.ZERO
var dedo_activo: int = -1
var radio_movimiento: float = 50.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	perilla.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Mostrar el joystick solamente en telefonos.
	visible = es_dispositivo_movil()

	centrar_perilla()


# ==========================================
# DETECCION DE DISPOSITIVO MOVIL
# ==========================================

func es_dispositivo_movil() -> bool:
	var sistema: String = OS.get_name()

	# Aplicaciones ejecutadas directamente en telefonos.
	if sistema == "Android" or sistema == "iOS":
		return true

	# Version web: distinguir telefono de computadora.
	if sistema == "Web":
		if not DisplayServer.is_touchscreen_available():
			return false

		var agente: String = JavaScriptBridge.eval(
			"navigator.userAgent",
			true
		)

		return (
			"Android" in agente
			or "iPhone" in agente
			or "iPad" in agente
			or "iPod" in agente
		)

	# Windows, Linux y macOS.
	return false


# ==========================================
# CONTROL TACTIL
# ==========================================

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventScreenTouch:
		var toque: InputEventScreenTouch = event

		if toque.pressed:
			if dedo_activo == -1 and _dentro_de_base(toque.position):
				dedo_activo = toque.index
				actualizar_direccion(toque.position)

		elif toque.index == dedo_activo:
			dedo_activo = -1
			reiniciar_joystick()

	elif event is InputEventScreenDrag:
		var arrastre: InputEventScreenDrag = event

		if arrastre.index == dedo_activo:
			actualizar_direccion(arrastre.position)


# ==========================================
# DETECTAR AREA DEL JOYSTICK
# ==========================================

func _dentro_de_base(posicion_pantalla: Vector2) -> bool:
	return base.get_global_rect().has_point(posicion_pantalla)


# ==========================================
# ACTUALIZAR DIRECCION
# ==========================================

func actualizar_direccion(posicion_pantalla: Vector2) -> void:
	var centro: Vector2 = base.global_position + base.size / 2.0
	var desplazamiento: Vector2 = posicion_pantalla - centro

	desplazamiento = desplazamiento.limit_length(radio_movimiento)

	perilla.position = (
		base.position
		+ base.size / 2.0
		- perilla.size / 2.0
		+ desplazamiento
	)

	var nueva_direccion: Vector2 = desplazamiento / radio_movimiento

	if nueva_direccion.length() < zona_muerta:
		nueva_direccion = Vector2.ZERO

	direccion = nueva_direccion
	direccion_cambiada.emit(direccion)


# ==========================================
# CENTRAR PERILLA
# ==========================================

func centrar_perilla() -> void:
	perilla.position = (
		base.position
		+ base.size / 2.0
		- perilla.size / 2.0
	)


# ==========================================
# REINICIAR JOYSTICK
# ==========================================

func reiniciar_joystick() -> void:
	direccion = Vector2.ZERO
	centrar_perilla()
	direccion_cambiada.emit(direccion)


# ==========================================
# OBTENER DIRECCION
# ==========================================

func obtener_direccion() -> Vector2:
	return direccion
