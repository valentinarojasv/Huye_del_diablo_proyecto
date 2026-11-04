extends CharacterBody2D

@export var configuracion: ConfiguracionDiablo

enum Estado {
	PERSEGUIR,
	ANUNCIAR,
	LATIGAZO,
	RECUPERAR,
	PREPARAR_EMBESTIDA,
	EMBESTIR
}

@onready var agente_navegacion: NavigationAgent2D = $NavigationAgent2D
@onready var latigo: Area2D = $Latigo
@onready var colision_latigo: CollisionShape2D = $Latigo/CollisionShape2D
@onready var advertencia_ataque: Polygon2D = $AdvertenciaAtaque
@onready var advertencia_embestida: Polygon2D = $AdvertenciaEmbestida
@onready var estela_embestida: GPUParticles2D = $EstelaEmbestida

const DISTANCIA_ATAQUE: float = 85.0

const TIEMPO_ACTIVACION_EMBESTIDA: float = 45.0
const INTERVALO_EMBESTIDA: float = 10.0
const DURACION_PREPARACION_EMBESTIDA: float = 0.8
const DURACION_EMBESTIDA: float = 0.6
const VELOCIDAD_EMBESTIDA: float = 650.0

const TIEMPO_EXTRA_ADVERTENCIA: float = 3.0

var jugador: CharacterBody2D
var tiempo_partida: float = 0.0

var estado_actual: Estado = Estado.PERSEGUIR
var tiempo_estado: float = 0.0
var direccion_ataque: Vector2 = Vector2.RIGHT

var jugador_golpeado_en_ataque: bool = false

var tiempo_ultima_embestida: float = 0.0
var direccion_embestida: Vector2 = Vector2.RIGHT

var jugador_en_zona_advertencia: bool = false
var advertencia_sonando: bool = false
var tiempo_fuera_advertencia: float = 0.0


func _ready() -> void:
	if configuracion == null:
		push_error("Diablo: falta asignar ConfiguracionDiablo.")
		set_physics_process(false)
		return

	jugador = get_tree().get_first_node_in_group("jugador") as CharacterBody2D

	if jugador == null:
		push_error("Diablo: no se encontró al jugador en el grupo 'jugador'.")
		set_physics_process(false)
		return

	agente_navegacion.path_desired_distance = 4.0
	agente_navegacion.target_desired_distance = 16.0

	colision_latigo.disabled = true
	advertencia_ataque.visible = false
	advertencia_embestida.visible = false
	estela_embestida.emitting = false


func _physics_process(delta: float) -> void:
	tiempo_partida += delta
	tiempo_estado += delta

	if not is_instance_valid(jugador):
		velocity = Vector2.ZERO
		advertencia_ataque.visible = false
		advertencia_embestida.visible = false
		estela_embestida.emitting = false
		detener_advertencia()
		return

	match estado_actual:
		Estado.PERSEGUIR:
			actualizar_persecucion()

		Estado.ANUNCIAR:
			actualizar_anuncio()

		Estado.LATIGAZO:
			actualizar_latigazo()

		Estado.RECUPERAR:
			actualizar_recuperacion()

		Estado.PREPARAR_EMBESTIDA:
			actualizar_preparacion_embestida()

		Estado.EMBESTIR:
			actualizar_embestida()

	actualizar_sonido_advertencia(delta)


func cambiar_estado(nuevo_estado: Estado) -> void:
	estado_actual = nuevo_estado
	tiempo_estado = 0.0

	velocity = Vector2.ZERO
	advertencia_ataque.visible = false
	advertencia_embestida.visible = false
	estela_embestida.emitting = false

	match nuevo_estado:
		Estado.PERSEGUIR:
			pass

		Estado.ANUNCIAR:
			direccion_ataque = global_position.direction_to(
				jugador.global_position
			)

			if direccion_ataque == Vector2.ZERO:
				direccion_ataque = Vector2.RIGHT

			latigo.rotation = direccion_ataque.angle()
			advertencia_ataque.rotation = direccion_ataque.angle()
			advertencia_ataque.visible = true

		Estado.LATIGAZO:
			jugador_golpeado_en_ataque = false
			colision_latigo.set_deferred("disabled", false)

		Estado.RECUPERAR:
			colision_latigo.set_deferred("disabled", true)

		Estado.PREPARAR_EMBESTIDA:
			direccion_embestida = global_position.direction_to(
				jugador.global_position
			)

			if direccion_embestida == Vector2.ZERO:
				direccion_embestida = Vector2.RIGHT

			advertencia_embestida.rotation = direccion_embestida.angle()
			advertencia_embestida.visible = true

			detener_advertencia()

		Estado.EMBESTIR:
			tiempo_ultima_embestida = tiempo_partida
			estela_embestida.emitting = true

			detener_advertencia()
			GestorAudio.reproducir_sonido("embestida")


func actualizar_persecucion() -> void:
	if puede_embestir():
		cambiar_estado(Estado.PREPARAR_EMBESTIDA)
		return

	var distancia: float = global_position.distance_to(
		jugador.global_position
	)

	if distancia <= DISTANCIA_ATAQUE:
		cambiar_estado(Estado.ANUNCIAR)
		return

	agente_navegacion.target_position = jugador.global_position

	if agente_navegacion.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var siguiente_posicion: Vector2 = (
		agente_navegacion.get_next_path_position()
	)

	var direccion: Vector2 = global_position.direction_to(
		siguiente_posicion
	)

	velocity = direccion * obtener_velocidad_actual()
	move_and_slide()


func actualizar_anuncio() -> void:
	velocity = Vector2.ZERO

	if tiempo_estado >= obtener_tiempo_aviso():
		cambiar_estado(Estado.LATIGAZO)


func actualizar_sonido_advertencia(delta: float) -> void:
	var dentro_zona: bool = false

	if estado_actual == Estado.ANUNCIAR and advertencia_ataque.visible:
		var posicion_local: Vector2 = advertencia_ataque.to_local(
			jugador.global_position
		)

		dentro_zona = Geometry2D.is_point_in_polygon(
			posicion_local,
			advertencia_ataque.polygon
		)

	if dentro_zona:
		tiempo_fuera_advertencia = 0.0

		if not jugador_en_zona_advertencia:
			jugador_en_zona_advertencia = true

			if not advertencia_sonando:
				GestorAudio.reproducir_sonido("advertencia")
				advertencia_sonando = true

	else:
		jugador_en_zona_advertencia = false

		if advertencia_sonando:
			tiempo_fuera_advertencia += delta

			if tiempo_fuera_advertencia >= TIEMPO_EXTRA_ADVERTENCIA:
				detener_advertencia()


func detener_advertencia() -> void:
	GestorAudio.detener_advertencia()

	advertencia_sonando = false
	jugador_en_zona_advertencia = false
	tiempo_fuera_advertencia = 0.0


func actualizar_latigazo() -> void:
	velocity = Vector2.ZERO

	if tiempo_estado >= configuracion.duracion_latigazo:
		cambiar_estado(Estado.RECUPERAR)


func actualizar_recuperacion() -> void:
	velocity = Vector2.ZERO

	if tiempo_estado >= obtener_tiempo_recuperacion():
		cambiar_estado(Estado.PERSEGUIR)


func puede_embestir() -> bool:
	if tiempo_partida < TIEMPO_ACTIVACION_EMBESTIDA:
		return false

	if tiempo_partida - tiempo_ultima_embestida < INTERVALO_EMBESTIDA:
		return false

	return true


func actualizar_preparacion_embestida() -> void:
	velocity = Vector2.ZERO

	if tiempo_estado >= DURACION_PREPARACION_EMBESTIDA:
		cambiar_estado(Estado.EMBESTIR)


func actualizar_embestida() -> void:
	velocity = direccion_embestida * VELOCIDAD_EMBESTIDA
	move_and_slide()

	if tiempo_estado >= DURACION_EMBESTIDA:
		cambiar_estado(Estado.RECUPERAR)


func obtener_velocidad_actual() -> float:
	if tiempo_partida < 15.0:
		return configuracion.velocidad_fase_1

	if tiempo_partida < 30.0:
		return configuracion.velocidad_fase_2

	if tiempo_partida < 45.0:
		return configuracion.velocidad_fase_3

	return configuracion.velocidad_fase_4


func obtener_tiempo_aviso() -> float:
	if tiempo_partida < 15.0:
		return configuracion.aviso_fase_1

	if tiempo_partida < 30.0:
		return configuracion.aviso_fase_2

	if tiempo_partida < 45.0:
		return configuracion.aviso_fase_3

	return configuracion.aviso_fase_4


func obtener_tiempo_recuperacion() -> float:
	if tiempo_partida < 45.0:
		return configuracion.recuperacion_inicial

	return configuracion.recuperacion_final


func _on_latigo_body_entered(body: Node2D) -> void:
	if estado_actual != Estado.LATIGAZO:
		return

	if jugador_golpeado_en_ataque:
		return

	if body != jugador:
		return

	jugador_golpeado_en_ataque = true

	if jugador.has_method("recibir_dano"):
		jugador.call("recibir_dano")
