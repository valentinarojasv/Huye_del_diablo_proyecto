extends Node

signal sonido_gameover_finalizado

const MUSICA_MENU: String = "res://audio/game.ogg"
const MUSICA_PARTIDA: String = "res://audio/juego.ogg"

const VOLUMEN_EXTRA_IMPACTO: float = 12.0

var reproductor_efectos: AudioStreamPlayer
var reproductor_advertencia: AudioStreamPlayer
var reproductor_embestida: AudioStreamPlayer
var reproductor_gameover: AudioStreamPlayer
var reproductor_musica: AudioStreamPlayer
var reproductor_pasos: AudioStreamPlayer
var reproductor_impacto: AudioStreamPlayer

var sonidos: Dictionary = {}

var advertencia_activa: bool = false
var ruta_musica_actual: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	reproductor_efectos = AudioStreamPlayer.new()
	reproductor_efectos.name = "ReproductorEfectos"
	add_child(reproductor_efectos)

	reproductor_advertencia = AudioStreamPlayer.new()
	reproductor_advertencia.name = "ReproductorAdvertencia"
	add_child(reproductor_advertencia)
	reproductor_advertencia.finished.connect(_on_advertencia_finalizada)

	reproductor_embestida = AudioStreamPlayer.new()
	reproductor_embestida.name = "ReproductorEmbestida"
	reproductor_embestida.volume_db = 6.0
	add_child(reproductor_embestida)

	reproductor_gameover = AudioStreamPlayer.new()
	reproductor_gameover.name = "ReproductorGameOver"
	add_child(reproductor_gameover)
	reproductor_gameover.finished.connect(_on_gameover_finalizado)

	reproductor_musica = AudioStreamPlayer.new()
	reproductor_musica.name = "ReproductorMusica"
	add_child(reproductor_musica)

	# Reproductor exclusivo para los pasos.
	reproductor_pasos = AudioStreamPlayer.new()
	reproductor_pasos.name = "ReproductorPasos"
	add_child(reproductor_pasos)
	reproductor_pasos.finished.connect(_on_pasos_finalizados)

	# Reproductor exclusivo para el impacto.
	reproductor_impacto = AudioStreamPlayer.new()
	reproductor_impacto.name = "ReproductorImpacto"
	reproductor_impacto.volume_db = VOLUMEN_EXTRA_IMPACTO
	add_child(reproductor_impacto)

	# Registro de sonidos.
	registrar_sonido("latigazo", "res://audio/Latigazo.ogg")
	registrar_sonido("advertencia", "res://audio/SonidoAdvertencia.ogg")
	registrar_sonido("embestida", "res://audio/embestida.ogg")
	registrar_sonido("gameover", "res://audio/gameoverr.ogg")
	registrar_sonido("pasos", "res://audio/Pasos.ogg")

	# Ruta corregida: impacto con i minuscula.
	registrar_sonido("impacto", "res://audio/impacto.ogg")

	if sonidos.has("pasos"):
		reproductor_pasos.stream = sonidos["pasos"]

	if sonidos.has("impacto"):
		reproductor_impacto.stream = sonidos["impacto"]


# ==========================================
# REGISTRO DE SONIDOS
# ==========================================

func registrar_sonido(nombre: String, ruta: String) -> void:
	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró el sonido: " + ruta)
		return

	sonidos[nombre] = load(ruta)


# ==========================================
# EFECTOS DE SONIDO
# ==========================================

func reproducir_sonido(nombre: String) -> void:
	if not sonidos.has(nombre):
		push_warning("Sonido no registrado: " + nombre)
		return

	match nombre:
		"advertencia":
			if advertencia_activa:
				return

			advertencia_activa = true
			reproductor_advertencia.stream = sonidos[nombre]
			reproductor_advertencia.play()

		"embestida":
			reproductor_embestida.stream = sonidos[nombre]
			reproductor_embestida.play()

		"gameover":
			reproductor_gameover.stop()
			reproductor_gameover.stream = sonidos[nombre]
			reproductor_gameover.play()

		"pasos":
			reproducir_pasos()

		"impacto":
			reproductor_impacto.play()

		_:
			reproductor_efectos.stream = sonidos[nombre]
			reproductor_efectos.play()


func _on_advertencia_finalizada() -> void:
	if advertencia_activa:
		reproductor_advertencia.play()


func detener_advertencia() -> void:
	advertencia_activa = false
	reproductor_advertencia.stop()


func detener_sonido() -> void:
	reproductor_efectos.stop()
	detener_advertencia()
	reproductor_embestida.stop()
	reproductor_gameover.stop()
	detener_pasos()
	reproductor_impacto.stop()


# ==========================================
# SONIDO DE PASOS
# ==========================================

func reproducir_pasos() -> void:
	if not sonidos.has("pasos"):
		return

	if reproductor_pasos.playing:
		return

	reproductor_pasos.play()


func detener_pasos() -> void:
	if reproductor_pasos.playing:
		reproductor_pasos.stop()


func _on_pasos_finalizados() -> void:
	if get_tree().paused:
		return

	if not reproductor_pasos.stream_paused:
		reproductor_pasos.play()


# ==========================================
# SONIDO DE GAME OVER
# ==========================================

func reproducir_gameover() -> void:
	detener_musica()
	detener_pasos()

	reproductor_efectos.stop()
	detener_advertencia()
	reproductor_embestida.stop()
	reproductor_impacto.stop()

	if not sonidos.has("gameover"):
		push_warning("No se encontró el sonido de Game Over.")
		sonido_gameover_finalizado.emit()
		return

	reproducir_sonido("gameover")


func _on_gameover_finalizado() -> void:
	sonido_gameover_finalizado.emit()


# ==========================================
# MUSICA DE FONDO
# ==========================================

func reproducir_musica(ruta: String) -> void:
	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró la música: " + ruta)
		return

	if ruta == ruta_musica_actual and reproductor_musica.playing:
		return

	var nueva_musica: AudioStream = load(ruta) as AudioStream

	if nueva_musica == null:
		push_warning("No se pudo cargar la música: " + ruta)
		return

	reproductor_musica.stop()
	reproductor_musica.stream = nueva_musica
	reproductor_musica.play()

	ruta_musica_actual = ruta


func reproducir_musica_menu() -> void:
	detener_pasos()
	reproducir_musica(MUSICA_MENU)


func reproducir_musica_partida() -> void:
	reproducir_musica(MUSICA_PARTIDA)


func detener_musica() -> void:
	reproductor_musica.stop()
	ruta_musica_actual = ""


# ==========================================
# COMPATIBILIDAD CON LA PAUSA
# ==========================================

func pausar_musica() -> void:
	reproductor_musica.stream_paused = true
	reproductor_pasos.stream_paused = true


func reanudar_musica() -> void:
	reproductor_musica.stream_paused = false
	reproductor_pasos.stream_paused = false


# ==========================================
# CONTROL DE VOLUMEN
# ==========================================

func establecer_volumen_efectos(volumen_db: float) -> void:
	reproductor_efectos.volume_db = volumen_db
	reproductor_advertencia.volume_db = volumen_db
	reproductor_embestida.volume_db = volumen_db + 6.0
	reproductor_gameover.volume_db = volumen_db
	reproductor_pasos.volume_db = volumen_db
	reproductor_impacto.volume_db = volumen_db + VOLUMEN_EXTRA_IMPACTO


func establecer_volumen_musica(volumen_db: float) -> void:
	reproductor_musica.volume_db = volumen_db
