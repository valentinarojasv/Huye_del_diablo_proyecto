extends Node

var reproductor_efectos: AudioStreamPlayer
var reproductor_advertencia: AudioStreamPlayer
var reproductor_embestida: AudioStreamPlayer
var reproductor_musica: AudioStreamPlayer

var sonidos: Dictionary = {}

var advertencia_activa: bool = false


func _ready() -> void:
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


func registrar_sonido(nombre: String, ruta: String) -> void:
	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró el sonido: " + ruta)
		return

	sonidos[nombre] = load(ruta)


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


func reproducir_musica(ruta: String) -> void:
	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró la música: " + ruta)
		return

	reproductor_musica.stream = load(ruta)
	reproductor_musica.play()


func detener_musica() -> void:
	reproductor_musica.stop()


func establecer_volumen_efectos(volumen_db: float) -> void:
	reproductor_efectos.volume_db = volumen_db
	reproductor_advertencia.volume_db = volumen_db
	reproductor_embestida.volume_db = volumen_db + 6.0


func establecer_volumen_musica(volumen_db: float) -> void:
	reproductor_musica.volume_db = volumen_db
