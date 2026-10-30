extends Resource
class_name ConfiguracionDiablo

@export_group("Fase 1: 0 a 15 segundos")
@export var velocidad_fase_1: float = 260.0
@export var aviso_fase_1: float = 0.60

@export_group("Fase 2: 15 a 30 segundos")
@export var velocidad_fase_2: float = 300.0
@export var aviso_fase_2: float = 0.50

@export_group("Fase 3: 30 a 45 segundos")
@export var velocidad_fase_3: float = 340.0
@export var aviso_fase_3: float = 0.40

@export_group("Fase 4: 45 segundos en adelante")
@export var velocidad_fase_4: float = 380.0
@export var aviso_fase_4: float = 0.30

@export_group("Ataques")
@export var duracion_latigazo: float = 0.15
@export var recuperacion_inicial: float = 0.70
@export var recuperacion_final: float = 0.40
