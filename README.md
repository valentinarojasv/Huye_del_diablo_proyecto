# Huye del Diablo

Huye del Diablo es un videojuego 2D desarrollado en Godot 4.x, inspirado en las mascaradas tradicionales de Costa Rica.

El objetivo es sobrevivir el mayor tiempo posible mientras un diablo persigue al jugador e intenta golpearlo con su látigo.

## Información del proyecto

- **Motor:** Godot 4.x
- **Lenguaje:** GDScript
- **Resolución:** 1280 × 720
- **Género:** Supervivencia y persecución 2D
- **Plataforma objetivo:** Web y dispositivos móviles
- **Estado:** En desarrollo
- **Última actualización:** 12 de noviembre de 2026

## Controles actuales

| **Acción** | **Control** |
| --- | --- |
| Movimiento | WASD o flechas |
| Turbo | Shift o espacio |
| Movimiento táctil | Joystick virtual |
| Turbo táctil | Botón de Turbo |
| Iniciar partida | Botón JUGAR |

## Funcionalidades implementadas

- Menú principal con botón JUGAR.
- Movimiento del jugador en ocho direcciones.
- Sistema de turbo con consumo y regeneración de energía.
- HUD con corazones, energía de Turbo y tiempo de supervivencia.
- Sistema de tres vidas representadas mediante corazones rojos.
- Cambio de corazones rojos a grises al perder vidas.
- Invulnerabilidad temporal después de recibir daño.
- Persecución del diablo mediante NavigationAgent2D.
- Sistema de ataques con látigo.
- Animación del látigo con estados de reposo y ataque.
- Configuración de la colisión del látigo durante los ataques.
- Advertencia visual antes de cada ataque.
- Sonidos de advertencia y latigazo.
- Incremento progresivo de la dificultad.
- Embestida especial del diablo a partir de los 45 segundos.
- Destello rojo al recibir daño.
- Sacudida de cámara.
- Finalización de la partida al perder todas las vidas.
- Pantalla Game Over con tiempo de supervivencia.
- Sistema de mejor tiempo de supervivencia.
- Recursos editables para configurar los valores del jugador y del diablo.
- Escenario ambientado en una plaza tradicional costarricense.
- Fuente central y caminos peatonales.
- Incorporación de árboles, jardineras y elementos decorativos.
- Incorporación de bancas y faroles.
- Incorporación de tiendas y puestos comerciales.
- Configuración de colisiones en los obstáculos del escenario.
- Implementación de límites para el movimiento del jugador.
- Configuración de NavigationRegion2D para la navegación del diablo.
- Incorporación de gráficos definitivos del jugador y del diablo.
- Incorporación de gráficos definitivos del látigo.
- Incorporación de gráficos definitivos de los obstáculos y del suelo de la plaza.
- Ambientación nocturna mediante CanvasModulate.
- Iluminación cálida de la plaza mediante PointLight2D.
- Rediseño del HUD con una combinación de colores oscuros y turquesa.
- Contador de tiempo con panel decorativo y texto de 18 píxeles.
- Barra de Turbo con fondo oscuro, relleno turquesa y bordes redondeados.
- Implementación del joystick virtual.
- Configuración de visibilidad del joystick para dispositivos táctiles.
- Incorporación del botón táctil de Turbo.
- Configuración del tamaño de los controles táctiles.
- Incorporación de la imagen del botón de pausa en el HUD.
- Organización de escenas, scripts, recursos gráficos y archivos de audio.

## Funcionalidades pendientes

- Confirmar el funcionamiento de los controles táctiles durante las pruebas de exportación.
- Confirmar la compatibilidad de los controles móviles.
- Completar la configuración de exportación Web utilizando el renderizador Compatibility.
- Generar la versión Web del videojuego.
- Preparar los archivos de distribución del proyecto.
- Realizar pruebas de compatibilidad y rendimiento en Google Chrome.
- Comprobar que el juego mantenga un rendimiento estable de 60 FPS.
- Completar la documentación y los archivos de entrega.
- Corregir los problemas de navegación que provocan que el diablo se atasque ocasionalmente con los obstáculos.

## Estructura del proyecto

- `Scenes/`: Escenas del menú, juego, personajes, obstáculos e interfaces.
- `Scripts/`: Código GDScript.
- `resources/`: Configuraciones editables del jugador y del diablo.
- `assets/`: Recursos gráficos definitivos del videojuego.
- `audio/`: Archivos de sonido.
- `autoload/`: Sistemas globales del juego.
- `README.md`: Documentación general del proyecto.

## Cómo ejecutar el proyecto

1. Descargar o clonar el repositorio.
2. Abrir Godot 4.x.
3. Importar el archivo `project.godot`.
4. Ejecutar el proyecto desde el editor.

## Estado actual

El juego cuenta con los sistemas principales de movimiento, turbo, persecución, ataques, vidas, cronómetro y puntuación.

Se ha completado la integración de los gráficos definitivos del jugador, el diablo, el látigo y los elementos del escenario. La plaza está inspirada en una localidad tradicional costarricense y cuenta con fuente central, caminos, bancas, árboles, jardineras, faroles y establecimientos comerciales.

Durante la tercera semana de desarrollo se mejoró la ambientación visual mediante una iluminación nocturna con tonos cálidos. Se incorporó CanvasModulate para oscurecer el escenario y PointLight2D para generar iluminación amarilla alrededor de los elementos de la plaza.

También se completó el rediseño del HUD. El indicador de vidas fue sustituido por tres corazones que cambian de rojo a gris cuando el jugador recibe daño. El contador de tiempo y la barra de Turbo recibieron un nuevo diseño con fondos oscuros, bordes redondeados y colores turquesa.

El diablo cuenta con animaciones de movimiento y ataque, además de un látigo animado cuya colisión se activa durante el golpe. Se mantienen las cuatro fases de dificultad, los avisos de ataque y la embestida especial.

Los parámetros del jugador y del diablo se encuentran organizados mediante recursos editables, permitiendo modificar velocidades, energía, tiempos de advertencia y recuperación desde el Inspector de Godot.

Los controles táctiles ya se encuentran configurados y su funcionamiento se confirmará durante las pruebas de exportación Web.

Actualmente, el proyecto se encuentra en la etapa de preparación para la exportación. Las siguientes actividades estarán enfocadas en configurar el renderizador Compatibility, generar la versión Web, verificar el rendimiento en Chrome y preparar los archivos de entrega.

Finalmente, queda pendiente corregir los problemas ocasionales de navegación que provocan que el diablo se atasque al rodear determinados obstáculos.
