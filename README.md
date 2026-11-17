# Huye del Diablo

Huye del Diablo es un videojuego 2D desarrollado en Godot 4.x, inspirado en las mascaradas tradicionales de Costa Rica.

El objetivo es sobrevivir el mayor tiempo posible mientras un diablo persigue al jugador e intenta golpearlo con su látigo.

## Información del proyecto

- **Motor:** Godot 4.x
- **Lenguaje:** GDScript
- **Resolución:** 1280 × 720
- **Género:** Supervivencia y persecución 2D
- **Plataforma objetivo:** Web y dispositivos móviles
- **Estado:** Etapa final de entrega

## Controles

| Acción | Control |
| --- | --- |
| Movimiento | WASD o flechas |
| Turbo | Shift o espacio |
| Movimiento táctil | Joystick virtual |
| Turbo táctil | Botón de Turbo |
| Iniciar partida | Botón JUGAR |

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

- Persecución del jugador mediante NavigationAgent2D.
- Navegación alrededor de los obstáculos del escenario.
- Sistema de ataques con látigo.
- Animaciones de reposo y ataque del látigo.
- Activación de la colisión del látigo durante los ataques.
- Advertencia visual antes de cada ataque.
- Sonidos de advertencia y latigazo.
- Cuatro fases de dificultad progresiva.
- Embestida especial a partir de los 45 segundos.

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

### Escenario

- Plaza inspirada en las localidades tradicionales de Costa Rica.
- Fuente central y caminos peatonales.
- Árboles, jardineras y elementos decorativos.
- Bancas y faroles.
- Tiendas y puestos comerciales.
- Obstáculos con colisiones.
- Límites de movimiento.
- Gráficos definitivos del jugador, diablo, látigo y escenario.
- Ambientación nocturna mediante CanvasModulate.
- Iluminación cálida mediante PointLight2D.

### Configuración técnica

- Recursos editables para los parámetros del jugador y del diablo.
- Organización de escenas, scripts, gráficos y audio.
- Renderizador Compatibility.
- Exportación Web mediante Godot 4.x.
- Ejecución del videojuego en Google Chrome.
- Configuración de controles táctiles.

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
3. Importar el archivo `project.godot`.
4. Ejecutar el proyecto desde el editor.

## Cómo ejecutar la versión Web

La versión Web se encuentra en la carpeta `Built_web`.

Para ejecutarla:

1. Utilizar un servidor HTTP local o un servicio de alojamiento Web compatible.
2. Servir los archivos contenidos en `Built_web`.
3. Abrir `index.html` desde Google Chrome mediante la dirección del servidor.

**Importante:** no se recomienda abrir `index.html` directamente mediante una dirección `file:///`, porque los navegadores pueden restringir la carga de los archivos necesarios para ejecutar Godot.

## Configuración editable

El videojuego utiliza recursos personalizados para modificar sus parámetros sin necesidad de editar directamente los scripts.

Entre los valores configurables se encuentran:

- Velocidad normal del jugador.
- Velocidad durante el Turbo.
- Energía máxima del Turbo.
- Consumo y regeneración de energía.
- Cantidad inicial de vidas.
- Duración de la invulnerabilidad.
- Velocidad del diablo.
- Tiempos de advertencia.
- Duración de los ataques.
- Tiempos de recuperación.

## Estado actual del proyecto

El videojuego cuenta con los sistemas principales de movimiento, Turbo, persecución, ataques, vidas, cronómetro y registro del mejor tiempo de supervivencia.

Se completó la integración de los gráficos definitivos y la ambientación nocturna de la plaza, incluyendo iluminación cálida, obstáculos y elementos decorativos.

También se finalizó el rediseño del HUD, incorporando corazones para representar las vidas y una barra de energía con colores turquesa.

El diablo utiliza NavigationAgent2D para perseguir al jugador y desplazarse alrededor de los obstáculos del escenario.

El proyecto utiliza el renderizador Compatibility y cuenta con una versión Web exportada y ejecutada en Google Chrome.

Los controles táctiles se encuentran configurados, incluyendo un joystick virtual y un botón de Turbo.

## Actividades finales

- Preparar el archivo ZIP de distribución Web.
- Organizar los archivos de entrega.
- Corregir cualquier incidencia detectada durante las últimas pruebas.

## Observaciones

Durante las pruebas en Chrome se detectó un comportamiento irregular de la barra de energía del Turbo, que debe revisarse antes de considerar validada completamente la versión final.

El objetivo de rendimiento del proyecto es mantener 60 FPS estables en Google Chrome.