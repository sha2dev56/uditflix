# UDITflix

Plataforma de contenido educativo y entretenimiento creada con Flutter.

## Funcionalidades

- **Catálogo**: contenido de demostración (vídeos, cómics y juegos) con filtros por tipo.
- **Ficha de contenido**: sinopsis, duración y accesos directos al reproductor o al arcade.
- **Reproductor de vídeo**: controles de play/pausa, salto de 10 segundos, barra de progreso y pantalla completa.
- **UDIT Arcade**: Flappy Bird sencillo dibujado con Flutter. Se controla tocando la pantalla o con Espacio / Flecha arriba / W, y guarda el récord durante la sesión.

## Diseño

Interfaz inspirada en las plataformas de streaming (estilo Netflix): fondo casi negro, acento rojo, cartelera destacada, filas de contenido en carrusel y fichas de detalle envolventes. Todos los estilos están centralizados en `lib/theme/app_theme.dart`.

## Ejecutar

```bash
flutter pub get
flutter run
```

## Pruebas

```bash
flutter analyze
flutter test
```
