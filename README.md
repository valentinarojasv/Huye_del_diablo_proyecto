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

## Controles actuales

| **Acción**      | **Control**     |
| --------------- | --------------- |
| Movimiento      | WASD o flechas  |
| Turbo           | Shift o espacio |
| Iniciar partida | Botón JUGAR     |

## Funcionalidades implementadas

- Menú principal con botón JUGAR.
- Movimiento del jugador en ocho direcciones.
- Sistema de turbo con consumo y regeneración de energía.
- HUD con indicador de vidas, energía y tiempo.
- Sistema de tres vidas.
- Invulnerabilidad temporal después de recibir daño.
- Persecución del diablo mediante NavigationAgent2D.
- Sistema de ataques con látigo.
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
- Creación de la escena base del joystick virtual.
- Incorporación de la imagen del botón de pausa en el HUD.

## Funcionalidades pendientes

- Completar el joystick virtual y su funcionamiento táctil.
- Implementar el botón táctil para activar el turbo.
- Programar el funcionamiento del botón de pausa.
- Incorporar los gráficos definitivos del jugador y del diablo.
- Completar los efectos visuales pendientes.
- Completar los efectos sonoros requeridos.
- Configurar la exportación web.
- Realizar pruebas de compatibilidad y rendimiento.

## Estructura del proyecto

- `Scenes/`: Escenas del menú, juego, personajes e interfaces.
- `Scripts/`: Código GDScript.
- `resources/`: Configuraciones editables.
- `assets/`: Recursos gráficos.
- `audio/`: Archivos de sonido.
- `autoload/`: Carpeta para sistemas globales.

## Cómo ejecutar el proyecto

1. Descargar o clonar el repositorio.
2. Abrir Godot 4.x.
3. Importar el archivo `project.godot`.
4. Ejecutar el proyecto desde el editor.

## Estado actual

El juego cuenta con los sistemas principales de movimiento, turbo, persecución, ataques, vidas, cronómetro y puntuación.

Se ha incorporado un escenario inspirado en una plaza tradicional costarricense, con fuente central, caminos, bancas, árboles, jardineras, faroles y establecimientos comerciales. También se han configurado las colisiones de los obstáculos y los límites del escenario.

El diablo cuenta con un sistema de persecución y ataques, aunque su navegación todavía puede presentar dificultades al rodear determinados obstáculos.

Actualmente se trabaja en los controles táctiles. Se ha creado la escena base del joystick virtual y se ha incorporado la imagen del botón de pausa, cuya programación está pendiente.

Las siguientes etapas del desarrollo estarán enfocadas en completar los controles móviles, incorporar los recursos gráficos definitivos y preparar la exportación web.
