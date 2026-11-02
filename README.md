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

| Acción | Control |
|---|---|
| Movimiento | WASD o flechas |
| Turbo | Shift o espacio |
| Iniciar partida | Botón JUGAR |

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
- Destello rojo al recibir daño.
- Sacudida de cámara.
- Finalización de la partida al perder todas las vidas.
- Pantalla Game Over con tiempo de supervivencia.
- Recursos editables para configurar los valores del jugador y del diablo.

## Funcionalidades pendientes

- Corregir la visualización del fondo de Game Over.
- Implementar el botón para reiniciar la partida.
- Completar el escenario y sus obstáculos.
- Incorporar los gráficos definitivos del jugador y del diablo.
- Implementar el joystick virtual y los controles táctiles.
- Incorporar los efectos visuales pendientes.
- Implementar la embestida del diablo en la última fase.
- Guardar y mostrar el mejor tiempo de supervivencia.
- Implementar el sistema de pausa.
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

El juego cuenta con los sistemas principales de movimiento, turbo, persecución, ataques, vidas y cronómetro.

Actualmente se continúa trabajando en la interfaz, el escenario y las funcionalidades necesarias para completar el proyecto.
