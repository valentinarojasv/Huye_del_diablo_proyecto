extends Node2D

signal tiempo_actualizado(segundos: int)

const ESCENA_MENU_PAUSA: PackedScene = preload(
	"res://Scenes/menu/menupausa.tscn"
)

const ESCENA_FIN_JUEGO: PackedScene = preload(
	"res://Scenes/ui/fin_juego.tscn"
)

const RUTA_MENU_PRINCIPAL: String = "res://Scenes/menu/MenuPrincipal.tscn"
const RUTA_JUEGO: String = "res://Scenes/game/juego.tscn"

const INTENSIDAD_SACUDIDA: float = 8.0
const DURACION_SACUDIDA: float = 0.20

@onready var cronometro: Timer = $Cronometro
@onready var jugador: CharacterBody2D = $Jugador
@onready var diablo: CharacterBody2D = $Diablo
@onready var destello_rojo: ColorRect = $EfectosPantalla/DestelloRojo
@onready var camara_jugador: Camera2D = $Jugador/CamaraJugador

var tiempo_supervivencia: int = 0
var partida_terminada: bool = false
var partida_pausada: bool = false

var menu_pausa: CanvasLayer = null
var fin_juego: CanvasLayer = null

var animacion_destello: Tween
var animacion_sacudida: Tween


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	tiempo_supervivencia = 0
	partida_terminada = false
	partida_pausada = false

	get_tree().paused = false

	# Estos nodos deben detenerse durante la pausa.
	cronometro.process_mode = Node.PROCESS_MODE_PAUSABLE
	jugador.process_mode = Node.PROCESS_MODE_PAUSABLE
	diablo.process_mode = Node.PROCESS_MODE_PAUSABLE

	cronometro.timeout.connect(_on_cronometro_timeout)
	jugador.dano_recibido.connect(_on_jugador_dano_recibido)
	jugador.jugador_derrotado.connect(_on_jugador_derrotado)

	tiempo_actualizado.emit(tiempo_supervivencia)


func _unhandled_input(event: InputEvent) -> void:
	if partida_terminada:
		return

	if event.is_action_pressed("pausa") and not event.is_echo():
		cambiar_pausa()
		get_viewport().set_input_as_handled()


# ==========================================
# SISTEMA DE PAUSA
# ==========================================

func cambiar_pausa() -> void:
	if partida_pausada:
		reanudar_partida()
	else:
		pausar_partida()


func pausar_partida() -> void:
	if partida_terminada or partida_pausada:
		return

	menu_pausa = ESCENA_MENU_PAUSA.instantiate() as CanvasLayer

	if menu_pausa == null:
		push_error("No se pudo crear el menú de pausa.")
		return

	get_tree().root.add_child(menu_pausa)

	menu_pausa.continuar_solicitado.connect(reanudar_partida)
	menu_pausa.menu_principal_solicitado.connect(volver_menu_principal)

	partida_pausada = true
	get_tree().paused = true


func reanudar_partida() -> void:
	if not partida_pausada:
		return

	get_tree().paused = false
	partida_pausada = false

	if is_instance_valid(menu_pausa):
		menu_pausa.queue_free()

	menu_pausa = null


# ==========================================
# CAMBIO DE ESCENAS
# ==========================================

func volver_menu_principal() -> void:
	cambiar_escena(RUTA_MENU_PRINCIPAL)


func reintentar_partida() -> void:
	cambiar_escena(RUTA_JUEGO)


func cambiar_escena(ruta: String) -> void:
	# Asegurar que la nueva escena no quede pausada.
	get_tree().paused = false
	partida_pausada = false

	# Eliminar las interfaces creadas mediante código.
	if is_instance_valid(menu_pausa):
		menu_pausa.queue_free()

	if is_instance_valid(fin_juego):
		fin_juego.queue_free()

	menu_pausa = null
	fin_juego = null

	# Cambiar de escena.
	var error: Error = get_tree().change_scene_to_file(ruta)

	if error != OK:
		push_error("No se pudo cargar la escena: " + ruta)


# ==========================================
# CRONÓMETRO
# ==========================================

func _on_cronometro_timeout() -> void:
	if partida_terminada or partida_pausada:
		return

	tiempo_supervivencia += 1
	tiempo_actualizado.emit(tiempo_supervivencia)


# ==========================================
# SISTEMA DE DAÑO
# ==========================================

func _on_jugador_dano_recibido() -> void:
	activar_destello_rojo()
	activar_sacudida_camara()


func _on_jugador_derrotado() -> void:
	if partida_terminada:
		return

	partida_terminada = true

	cronometro.stop()

	jugador.set_physics_process(false)
	diablo.set_physics_process(false)

	jugador.velocity = Vector2.ZERO
	diablo.velocity = Vector2.ZERO

	# Guardar el récord antes de mostrar Game Over.
	GestorRecords.registrar_tiempo(tiempo_supervivencia)

	mostrar_game_over()


# ==========================================
# PANTALLA GAME OVER
# ==========================================

func mostrar_game_over() -> void:
	if is_instance_valid(fin_juego):
		return

	fin_juego = ESCENA_FIN_JUEGO.instantiate() as CanvasLayer

	if fin_juego == null:
		push_error("No se pudo crear la pantalla Game Over.")
		return

	# Cargar Game Over fuera de la escena Juego.
	get_tree().root.add_child(fin_juego)

	# Mostrar el tiempo sobrevivido.
	fin_juego.mostrar_tiempo(tiempo_supervivencia)

	# Conectar los botones.
	fin_juego.reintentar_solicitado.connect(reintentar_partida)
	fin_juego.menu_principal_solicitado.connect(volver_menu_principal)


# ==========================================
# EFECTOS DE DAÑO
# ==========================================

func activar_destello_rojo() -> void:
	if animacion_destello != null:
		if animacion_destello.is_running():
			animacion_destello.kill()

	destello_rojo.visible = true
	destello_rojo.modulate.a = 1.0

	animacion_destello = create_tween()

	animacion_destello.tween_property(
		destello_rojo,
		"modulate:a",
		0.0,
		0.25
	)

	animacion_destello.tween_callback(
		func() -> void:
			destello_rojo.visible = false
	)


func activar_sacudida_camara() -> void:
	if animacion_sacudida != null:
		if animacion_sacudida.is_running():
			animacion_sacudida.kill()

	camara_jugador.offset = Vector2.ZERO

	animacion_sacudida = create_tween()

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2(
			INTENSIDAD_SACUDIDA,
			-INTENSIDAD_SACUDIDA
		),
		DURACION_SACUDIDA / 4.0
	)

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2(
			-INTENSIDAD_SACUDIDA,
			INTENSIDAD_SACUDIDA
		),
		DURACION_SACUDIDA / 4.0
	)

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2(
			INTENSIDAD_SACUDIDA / 2.0,
			0.0
		),
		DURACION_SACUDIDA / 4.0
	)

	animacion_sacudida.tween_property(
		camara_jugador,
		"offset",
		Vector2.ZERO,
		DURACION_SACUDIDA / 4.0
	)


func _exit_tree() -> void:
	get_tree().paused = false

	if is_instance_valid(menu_pausa):
		menu_pausa.queue_free()

	if is_instance_valid(fin_juego):
		fin_juego.queue_free()
