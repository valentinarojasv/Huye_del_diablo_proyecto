# Huye del Diablo

Huye del Diablo es un videojuego 2D desarrollado en Godot 4.x, inspirado en las mascaradas tradicionales de Costa Rica.

El objetivo es sobrevivir el mayor tiempo posible mientras un diablo persigue al jugador e intenta golpearlo con su látigo.

## Información del proyecto

- **Motor:** Godot 4.x
- **Lenguaje:** GDScript
- **Resolución:** 1280 × 720
- **Género:** Supervivencia y persecución 2D
- **Plataforma objetivo:** Navegadores Web de escritorio y dispositivos móviles
- **Renderizador:** Compatibility
- **Estado:** Etapa final de entrega

## Controles

| Acción | Control |
| --- | --- |
| Movimiento | WASD o flechas |
| Turbo | Shift o espacio |
| Movimiento táctil | Joystick virtual |
| Turbo táctil | Botón de Turbo |
| Pausar partida | Botón de pausa |
| Iniciar partida | Botón JUGAR |

### Controles táctiles

En dispositivos móviles, el jugador utiliza un joystick virtual situado en el lado izquierdo de la pantalla.

El joystick permanece oculto hasta que el usuario toca su área de control. Mientras mantiene el dedo presionado, puede desplazar la perilla para mover al personaje.

Al levantar el dedo, la perilla vuelve al centro y el joystick desaparece.

El joystick utiliza una zona muerta de `0.2` para evitar movimientos involuntarios.

El botón de Turbo permite activar la velocidad adicional durante el movimiento.

Los controles móviles y los indicadores del HUD se encuentran dentro de un `CanvasLayer`, por lo que mantienen su posición en pantalla mientras la cámara sigue al jugador.

## Funcionalidades implementadas

### Jugador

- Movimiento en ocho direcciones.
- Sistema de Turbo con consumo y regeneración de energía.
- Tres vidas representadas mediante corazones.
- Cambio de corazones rojos a grises al recibir daño.
- Invulnerabilidad temporal después de recibir daño.
- Animaciones de movimiento.
- Efectos visuales de desplazamiento y Turbo.
- Sonidos de pasos.

### Diablo

- Persecución del jugador mediante `NavigationAgent2D`.
- Navegación alrededor de los obstáculos del escenario.
- Sistema de ataques con látigo.
- Animaciones de reposo y ataque del látigo.
- Activación temporal de la colisión del látigo.
- Advertencia visual antes de cada ataque.
- Sonidos de advertencia y latigazo.
- Cuatro fases de dificultad progresiva.
- Embestida especial a partir de los 45 segundos.
- Parámetros de la embestida configurables mediante un `Resource`.

### Interfaz

- Menú principal con botón JUGAR.
- HUD con tres corazones, barra de Turbo y cronómetro.
- Contador de tiempo con panel decorativo.
- Barra de Turbo con fondo oscuro y relleno turquesa.
- Pantalla Game Over.
- Registro del mejor tiempo de supervivencia.
- Botón de pausa.
- Joystick virtual para dispositivos táctiles.
- Botón táctil de Turbo.
- `CanvasLayer` para mantener los controles y el HUD fijos en pantalla.

### Escenario

- Plaza inspirada en las localidades tradicionales de Costa Rica.
- Fuente central y caminos peatonales.
- Árboles, jardineras y elementos decorativos.
- Bancas y faroles.
- Tiendas y puestos comerciales.
- Obstáculos con colisiones.
- Límites de movimiento.
- Gráficos definitivos del jugador, diablo, látigo y escenario.
- Ambientación nocturna mediante `CanvasModulate`.
- Iluminación cálida mediante `PointLight2D`.

### Configuración técnica

- Recursos editables para los parámetros del jugador y del diablo.
- Organización de escenas, scripts, gráficos y audio.
- Renderizador Compatibility.
- Exportación Web mediante Godot 4.x.
- Ejecución del videojuego en Google Chrome.
- Configuración de controles táctiles.
- Persistencia del mejor tiempo mediante `ConfigFile`.

## Estructura del proyecto

- `Scenes/`: Escenas del menú, juego, personajes, obstáculos e interfaces.
- `Scripts/`: Código GDScript.
- `resources/`: Configuraciones editables del jugador y del diablo.
- `assets/`: Recursos gráficos del videojuego.
- `audio/`: Archivos de sonido.
- `autoload/`: Sistemas globales.
- `Built_web/`: Archivos generados para la versión Web.
- `README.md`: Documentación general.
- `project.godot`: Archivo principal del proyecto Godot.

## Cómo ejecutar el proyecto en Godot

1. Descargar o clonar el repositorio.
2. Abrir Godot 4.x.
3. Seleccionar la opción para importar un proyecto existente.
4. Localizar y seleccionar el archivo `project.godot`.
5. Abrir el proyecto.
6. Ejecutar el videojuego desde el editor.

## Cómo exportar el proyecto a Web

1. Abrir el proyecto en Godot 4.x.
2. Acceder a **Proyecto > Exportar**.
3. Seleccionar el preset de exportación Web.
4. Comprobar que las plantillas de exportación estén instaladas.
5. Seleccionar la carpeta de destino `Built_web`.
6. Exportar el proyecto utilizando `index.html` como archivo principal.
7. Conservar todos los archivos generados por Godot dentro de la carpeta de distribución.

La exportación debe utilizar una configuración compatible con los navegadores Web y el renderizador Compatibility.

## Cómo ejecutar la versión Web

La versión Web se encuentra en la carpeta `Built_web`.

Para ejecutarla:

1. Utilizar un servidor HTTP local o un servicio de alojamiento Web compatible.
2. Servir los archivos contenidos en `Built_web`.
3. Abrir el juego desde Google Chrome mediante la dirección proporcionada por el servidor.
4. Iniciar la partida desde el menú principal.

**Importante:** no se recomienda abrir `index.html` directamente mediante una dirección `file:///`, porque los navegadores pueden restringir la carga de los archivos necesarios para ejecutar Godot.

En dispositivos móviles, el juego debe abrirse desde un navegador compatible con la ejecución de contenido Web.

## Configuración editable

El videojuego utiliza recursos personalizados para modificar sus parámetros sin necesidad de editar directamente los scripts.

### Configuración del jugador

Entre los parámetros configurables se encuentran:

- Velocidad normal.
- Velocidad durante el Turbo.
- Energía máxima del Turbo.
- Consumo de energía.
- Regeneración de energía.
- Cantidad inicial de vidas.
- Duración de la invulnerabilidad.

### Configuración del diablo

El recurso `ConfiguracionDiablo` permite modificar los parámetros de las cuatro fases de dificultad.

| Fase | Tiempo de supervivencia | Velocidad del diablo | Tiempo de advertencia |
| --- | --- | --- | --- |
| 1 | 0–15 segundos | 260 px/s | 0.60 s |
| 2 | 15–30 segundos | 300 px/s | 0.50 s |
| 3 | 30–45 segundos | 340 px/s | 0.40 s |
| 4 | 45 segundos en adelante | 380 px/s | 0.30 s |

También permite modificar:

- Duración del latigazo: `0.15 s`.
- Recuperación inicial: `0.70 s`.
- Recuperación final: `0.40 s`.

### Configuración de la embestida

Los parámetros de la embestida se encuentran dentro del grupo **Embestida** del recurso `ConfiguracionDiablo`.

| Parámetro | Valor predeterminado |
| --- | --- |
| Tiempo de activación | 45 segundos |
| Intervalo entre embestidas | 10 segundos |
| Duración de preparación | 0.8 segundos |
| Duración de la embestida | 0.6 segundos |
| Velocidad de embestida | 650 px/s |

Estos valores pueden modificarse desde el Inspector de Godot sin editar el código del enemigo.

## Sistema de récord

El videojuego registra el mejor tiempo de supervivencia alcanzado por el jugador.

El sistema utiliza el autoload `GestorRecords` para administrar los registros.

El récord se almacena mediante `ConfigFile` en la siguiente ubicación:

`user://record.cfg`

La configuración utiliza:

- **Sección:** `records`
- **Clave:** `mejor_tiempo`

El sistema carga el récord al iniciar el juego y guarda un nuevo valor únicamente cuando el jugador supera su mejor tiempo anterior.

También incluye un mecanismo de migración para recuperar registros existentes del archivo anterior `user://record.dat`.

En la versión Web, el almacenamiento `user://` depende del almacenamiento persistente que proporciona el navegador.

## Recursos gráficos y de audio

### Recursos gráficos

El proyecto utiliza gráficos definitivos para:

- Jugador.
- Diablo.
- Látigo.
- Escenario.
- Obstáculos.
- Elementos decorativos.
- Interfaz del juego.

### Recursos de audio

El videojuego incorpora sonidos asociados con:

- Movimiento del jugador.
- Advertencias de ataque.
- Latigazos.
- Embestidas.

Los recursos gráficos y de audio utilizados se encuentran organizados dentro de las carpetas correspondientes del proyecto.

La identificación de autores, licencias y procedencia de los recursos externos debe conservarse junto con los archivos de entrega cuando corresponda.

## Estado actual del proyecto

El videojuego cuenta con los sistemas principales de movimiento, Turbo, persecución, ataques, vidas, cronómetro y registro del mejor tiempo de supervivencia.

Se completó la integración de los gráficos definitivos y la ambientación nocturna de la plaza, incluyendo iluminación cálida, obstáculos y elementos decorativos.

También se finalizó el rediseño del HUD, incorporando corazones para representar las vidas y una barra de energía con colores turquesa.

El diablo utiliza `NavigationAgent2D` para perseguir al jugador y desplazarse alrededor de los obstáculos del escenario.

Los parámetros de dificultad y embestida se administran mediante un recurso editable.

El proyecto utiliza el renderizador Compatibility y cuenta con una versión Web exportada y ejecutada en Google Chrome.

Los controles táctiles incluyen un joystick virtual que aparece al tocar su área y un botón de Turbo.

El sistema de récord utiliza `ConfigFile` para guardar el mejor tiempo.

## Pruebas y compatibilidad

### Funcionalidades revisadas durante el desarrollo

- Movimiento mediante teclado.
- Movimiento mediante joystick virtual.
- Activación del Turbo.
- Consumo y regeneración de energía.
- Actualización de los corazones.
- Funcionamiento del cronómetro.
- Persecución del diablo.
- Ataques con látigo.
- Embestida especial.
- Registro del mejor tiempo.
- Posición fija del HUD y los controles móviles.

### Validación final pendiente

Antes de la entrega se debe completar la validación de:

- Ejecución en Google Chrome.
- Ejecución en Mozilla Firefox.
- Ejecución en Microsoft Edge.
- Funcionamiento en dispositivos móviles.
- Persistencia del récord después de cerrar y volver a abrir el juego.
- Ausencia de errores en la consola.
- Rendimiento objetivo de 60 FPS en Chrome de escritorio.

## Actividades finales

- Preparar el archivo ZIP de distribución Web.
- Organizar los archivos de entrega.
- Completar la validación final de compatibilidad y rendimiento.
- Corregir cualquier incidencia confirmada durante las últimas pruebas.

## Problemas conocidos y observaciones

Durante una prueba anterior en Chrome se detectó un comportamiento irregular de la barra de energía del Turbo.

Posteriormente se realizaron correcciones en la organización del HUD y los controles móviles. El funcionamiento de la barra de Turbo debe confirmarse nuevamente en la exportación Web final.

No se documentan otros problemas conocidos como confirmados en esta versión.

El objetivo de rendimiento del proyecto es mantener **60 FPS estables en Google Chrome de escritorio**.

## Entrega

La entrega del proyecto debe incluir:

- Proyecto editable de Godot 4.x.
- Archivo `project.godot`.
- Escenas, scripts y recursos utilizados.
- Archivo `README.md`.
- Historial de desarrollo mediante Git.
- Carpeta con la exportación Web.
- Registro breve del avance semanal.
