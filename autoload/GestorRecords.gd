extends Node

signal record_actualizado(nuevo_record: int)

const RUTA_GUARDADO: String = "user://record.cfg"
const SECCION_RECORD: String = "records"
const CLAVE_MEJOR_TIEMPO: String = "mejor_tiempo"

const RUTA_GUARDADO_ANTERIOR: String = "user://record.dat"

var mejor_tiempo: int = 0


func _ready() -> void:
	cargar_record()


# ==========================================
# CARGAR RECORD
# ==========================================

func cargar_record() -> void:
	mejor_tiempo = 0

	var configuracion: ConfigFile = ConfigFile.new()
	var resultado: Error = configuracion.load(RUTA_GUARDADO)

	if resultado == OK:
		mejor_tiempo = maxi(
			int(
				configuracion.get_value(
					SECCION_RECORD,
					CLAVE_MEJOR_TIEMPO,
					0
				)
			),
			0
		)
		return

	if resultado == ERR_FILE_NOT_FOUND:
		migrar_record_anterior()
		return

	push_warning("No se pudo cargar el récord.")


# ==========================================
# MIGRAR RECORD ANTERIOR
# ==========================================

func migrar_record_anterior() -> void:
	if not FileAccess.file_exists(RUTA_GUARDADO_ANTERIOR):
		return

	var archivo: FileAccess = FileAccess.open(
		RUTA_GUARDADO_ANTERIOR,
		FileAccess.READ
	)

	if archivo == null:
		push_warning("No se pudo recuperar el récord anterior.")
		return

	mejor_tiempo = maxi(archivo.get_32(), 0)
	archivo.close()

	guardar_record()


# ==========================================
# GUARDAR RECORD
# ==========================================

func guardar_record() -> void:
	var configuracion: ConfigFile = ConfigFile.new()

	configuracion.set_value(
		SECCION_RECORD,
		CLAVE_MEJOR_TIEMPO,
		mejor_tiempo
	)

	var resultado: Error = configuracion.save(RUTA_GUARDADO)

	if resultado != OK:
		push_error("No se pudo guardar el récord.")
		return

	# Solicitar sincronizacion del almacenamiento Web.
	if OS.has_feature("web"):
		_sincronizar_guardado_web()


# ==========================================
# SINCRONIZACION WEB
# ==========================================

func _sincronizar_guardado_web() -> void:
	JavaScriptBridge.eval(
		"""
		(function() {
			if (typeof FS !== 'undefined' && FS.syncfs) {
				FS.syncfs(false, function(error) {
					if (error) {
						console.error(
							'Error al sincronizar el récord:',
							error
						);
					}
				});
			}
		})();
		""",
		true
	)


# ==========================================
# REGISTRAR TIEMPO
# ==========================================

func registrar_tiempo(tiempo: int) -> void:
	if tiempo <= mejor_tiempo:
		return

	mejor_tiempo = tiempo
	guardar_record()
	record_actualizado.emit(mejor_tiempo)


# ==========================================
# OBTENER RECORD
# ==========================================

func obtener_record() -> int:
	return mejor_tiempo
