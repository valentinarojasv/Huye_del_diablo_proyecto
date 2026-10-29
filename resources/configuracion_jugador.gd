extends Resource
class_name ConfiguracionJugador

@export_group("Movimiento")
@export var velocidad_normal: float = 340.0
@export var velocidad_turbo: float = 540.0

@export_group("Turbo")
@export var energia_maxima: float = 100.0
@export var consumo_turbo: float = 40.0
@export var regeneracion_turbo: float = 15.0
@export var retraso_regeneracion: float = 0.5
@export var energia_minima_reactivacion: float = 30.0

@export_group("Supervivencia")
@export var vidas_iniciales: int = 3
@export var duracion_invulnerabilidad: float = 1.5
