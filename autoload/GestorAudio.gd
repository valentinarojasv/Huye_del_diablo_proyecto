extends Node

var reproductor_efectos: AudioStreamPlayer
var reproductor_advertencia: AudioStreamPlayer
var reproductor_embestida: AudioStreamPlayer
var reproductor_musica: AudioStreamPlayer

var sonidos: Dictionary = {}

var advertencia_activa: bool = false

var musica_pausada: bool = false
var ruta_musica_actual: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	reproductor_efectos = AudioStreamPlayer.new()
	reproductor_efectos.name = "ReproductorEfectos"
	add_child(reproductor_efectos)

	reproductor_advertencia = AudioStreamPlayer.new()
	reproductor_advertencia.name = "ReproductorAdvertencia"
	add_child(reproductor_advertencia)

	reproductor_advertencia.finished.connect(
		_on_advertencia_finalizada
	)

	reproductor_embestida = AudioStreamPlayer.new()
	reproductor_embestida.name = "ReproductorEmbestida"
	reproductor_embestida.volume_db = 6.0
	add_child(reproductor_embestida)

	reproductor_musica = AudioStreamPlayer.new()
	reproductor_musica.name = "ReproductorMusica"
	add_child(reproductor_musica)

	registrar_sonido("latigazo", "res://audio/Latigazo.ogg")
	registrar_sonido("advertencia", "res://audio/SonidoAdvertencia.ogg")
	registrar_sonido("embestida", "res://audio/embestida.ogg")


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


# ==========================================
# MUSICA DE FONDO
# ==========================================

func reproducir_musica(ruta: String) -> void:
	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró la música: " + ruta)
		return

	# Evitar reiniciar una canción que ya está sonando.
	if ruta == ruta_musica_actual:
		if reproductor_musica.playing and not musica_pausada:
			return

	# Detener la canción anterior.
	reproductor_musica.stop()

	var nueva_musica: AudioStream = load(ruta) as AudioStream

	if nueva_musica == null:
		push_warning("No se pudo cargar la música: " + ruta)
		return

	reproductor_musica.stream = nueva_musica
	reproductor_musica.play()

	ruta_musica_actual = ruta
	musica_pausada = false


func detener_musica() -> void:
	reproductor_musica.stop()

	musica_pausada = false
	ruta_musica_actual = ""


# ==========================================
# PAUSAR Y REANUDAR MUSICA
# ==========================================

func pausar_musica() -> void:
	if reproductor_musica.playing and not musica_pausada:
		reproductor_musica.stream_paused = true
		musica_pausada = true


func reanudar_musica() -> void:
	if musica_pausada:
		reproductor_musica.stream_paused = false
		musica_pausada = false


# ==========================================
# CONTROL DE VOLUMEN
# ==========================================

func establecer_volumen_efectos(volumen_db: float) -> void:
	reproductor_efectos.volume_db = volumen_db
	reproductor_advertencia.volume_db = volumen_db
	reproductor_embestida.volume_db = volumen_db + 6.0


func establecer_volumen_musica(volumen_db: float) -> void:
	reproductor_musica.volume_db = volumen_db
