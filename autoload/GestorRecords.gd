extends Node

signal record_actualizado(nuevo_record: int)

const RUTA_GUARDADO: String = "user://record.dat"

var mejor_tiempo: int = 0


func _ready() -> void:
	cargar_record()


func cargar_record() -> void:
	mejor_tiempo = 0

	if not FileAccess.file_exists(RUTA_GUARDADO):
		return

	var archivo: FileAccess = FileAccess.open(
		RUTA_GUARDADO,
		FileAccess.READ
	)

	if archivo == null:
		push_warning("No se pudo cargar el récord.")
		return

	mejor_tiempo = maxi(archivo.get_32(), 0)
	archivo.close()


func guardar_record() -> void:
	var archivo: FileAccess = FileAccess.open(
		RUTA_GUARDADO,
		FileAccess.WRITE
	)

	if archivo == null:
		push_error("No se pudo guardar el récord.")
		return

	archivo.store_32(mejor_tiempo)
	archivo.close()


func registrar_tiempo(tiempo: int) -> void:
	if tiempo <= mejor_tiempo:
		return

	mejor_tiempo = tiempo
	guardar_record()
	record_actualizado.emit(mejor_tiempo)


func obtener_record() -> int:
	return mejor_tiempo
