extends CharacterBody2D

@export var configuracion: ConfiguracionDiablo

enum Estado {
	PERSEGUIR,
	ANUNCIAR,
	LATIGAZO,
	RECUPERAR
}

@onready var agente_navegacion: NavigationAgent2D = $NavigationAgent2D
@onready var latigo: Area2D = $Latigo
@onready var colision_latigo: CollisionShape2D = $Latigo/CollisionShape2D

const DISTANCIA_ATAQUE: float = 85.0

var jugador: CharacterBody2D
var tiempo_partida: float = 0.0

var estado_actual: Estado = Estado.PERSEGUIR
var tiempo_estado: float = 0.0
var direccion_ataque: Vector2 = Vector2.RIGHT

var jugador_golpeado_en_ataque: bool = false


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


func _physics_process(delta: float) -> void:
	tiempo_partida += delta
	tiempo_estado += delta

	if not is_instance_valid(jugador):
		velocity = Vector2.ZERO
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


func cambiar_estado(nuevo_estado: Estado) -> void:
	estado_actual = nuevo_estado
	tiempo_estado = 0.0

	velocity = Vector2.ZERO

	if nuevo_estado == Estado.ANUNCIAR:
		direccion_ataque = global_position.direction_to(
			jugador.global_position
		)

		if direccion_ataque == Vector2.ZERO:
			direccion_ataque = Vector2.RIGHT

		latigo.rotation = direccion_ataque.angle()

	if nuevo_estado == Estado.LATIGAZO:
		jugador_golpeado_en_ataque = false
		colision_latigo.set_deferred("disabled", false)

	if nuevo_estado == Estado.RECUPERAR:
		colision_latigo.set_deferred("disabled", true)


func actualizar_persecucion() -> void:
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


func actualizar_latigazo() -> void:
	velocity = Vector2.ZERO

	if tiempo_estado >= configuracion.duracion_latigazo:
		cambiar_estado(Estado.RECUPERAR)


func actualizar_recuperacion() -> void:
	velocity = Vector2.ZERO

	if tiempo_estado >= obtener_tiempo_recuperacion():
		cambiar_estado(Estado.PERSEGUIR)


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
