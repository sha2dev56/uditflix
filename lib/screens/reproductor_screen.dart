// REPRODUCTOR DE VÍDEO DE UDITFLIX

// Pantalla de reproducción que se abre desde la ficha de un contenido.
// Utiliza video_player y dispone de controles básicos (play/pausa,
// retroceso/avance, barra de progreso y pantalla completa).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../data/contenidos.dart';
import '../models/contenido.dart';

class ReproductorScreen extends StatefulWidget {
    const ReproductorScreen({
        super.key,
        required this.contenido,
    });

    final Contenido contenido;

    @override
    State<ReproductorScreen> createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
    late final VideoPlayerController _controller;
    bool _cargando = true;
    String? _error;

    @override
    void initState() {
        super.initState();

        // Si el contenido no trae vídeo propio se usa el de demostración.
        final url = widget.contenido.urlVideo ?? urlVideoDemostracion;
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));

        _controller.initialize().then((_) async {
            await _controller.setLooping(true);
            if (!mounted) return;
            setState(() => _cargando = false);
        }).onError((Object error, StackTrace stackTrace) {
            if (!mounted) return;
            setState(() {
                _cargando = false;
                _error = error.toString();
            });
        });
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    void _abrirPantallaCompleta() {
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (_) => _PantallaCompleta(controller: _controller),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text(widget.contenido.titulo)),
            body: _contenido(),
        );
    }

    Widget _contenido() {
        if (_error != null) {
            return Center(
                child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Icon(Icons.error_outline,
                                size: 56,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 16),
                            const Text(
                                'No se pudo cargar el vídeo. '
                                'Comprueba tu conexión a Internet.',
                                textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(_error!, textAlign: TextAlign.center),
                        ],
                    ),
                ),
            );
        }

        if (_cargando) {
            return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    VisorVideo(
                        controller: _controller,
                        onPantallaCompleta: _abrirPantallaCompleta,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    widget.contenido.titulo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    '${widget.contenido.tipo} · '
                                    '${widget.contenido.duracion}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.65),
                                    ),
                                ),
                                const SizedBox(height: 16),
                                Text(widget.contenido.descripcion),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

// Ruta a pantalla completa: comparte el controlador con la pantalla normal
// para no reiniciar el vídeo al entrar o salir de ella.
class _PantallaCompleta extends StatefulWidget {
    const _PantallaCompleta({required this.controller});

    final VideoPlayerController controller;

    @override
    State<_PantallaCompleta> createState() => _PantallaCompletaState();
}

class _PantallaCompletaState extends State<_PantallaCompleta> {
    @override
    void initState() {
        super.initState();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
        ]);
    }

    @override
    void dispose() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: VisorVideo(
                    controller: widget.controller,
                    onSalir: () => Navigator.of(context).pop(),
                ),
            ),
        );
    }
}

// Visor reutilizable: muestra el vídeo y una superposición de controles.
class VisorVideo extends StatefulWidget {
    const VisorVideo({
        super.key,
        required this.controller,
        this.onPantallaCompleta,
        this.onSalir,
    });

    final VideoPlayerController controller;
    final VoidCallback? onPantallaCompleta;
    final VoidCallback? onSalir;

    @override
    State<VisorVideo> createState() => _VisorVideoState();
}

class _VisorVideoState extends State<VisorVideo> {
    bool _mostrarControles = true;

    void _alternarControles() {
        setState(() => _mostrarControles = !_mostrarControles);
    }

    void _saltar(Duration delta) {
        final valor = widget.controller.value;
        final destino = valor.position + delta;
        final fin = valor.duration;
        widget.controller.seekTo(
            destino.isNegative ? Duration.zero : (destino > fin ? fin : destino),
        );
    }

    @override
    Widget build(BuildContext context) {
        return ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: widget.controller,
            builder: (context, value, _) {
                return GestureDetector(
                    onTap: _alternarControles,
                    child: AspectRatio(
                        aspectRatio:
                            value.aspectRatio > 0 ? value.aspectRatio : 16 / 9,
                        child: Container(
                            color: Colors.black,
                            child: Stack(
                                alignment: Alignment.center,
                                children: [
                                    VideoPlayer(widget.controller),
                                    if (value.isBuffering)
                                        const CircularProgressIndicator(),
                                    if (!value.isPlaying && !value.isBuffering)
                                        _botonCentral(),
                                    if (_mostrarControles)
                                        Positioned.fill(
                                            child: _controles(value),
                                        ),
                                ],
                            ),
                        ),
                    ),
                );
            },
        );
    }

    Widget _botonCentral() {
        return IconButton(
            iconSize: 56,
            color: Colors.white,
            icon: const Icon(Icons.play_circle_fill),
            onPressed: () => widget.controller.play(),
        );
    }

    Widget _controles(VideoPlayerValue value) {
        return DecoratedBox(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB3000000)],
                ),
            ),
            child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        _botonPantallaCompleta(),
                        _barraProgreso(value),
                        _filaReproduccion(value),
                    ],
                ),
            ),
        );
    }

    Widget _botonPantallaCompleta() {
        final salir = widget.onSalir;
        final expandir = widget.onPantallaCompleta;
        if (salir == null && expandir == null) return const SizedBox.shrink();

        return Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                color: Colors.white,
                tooltip: salir != null
                    ? 'Salir de pantalla completa'
                    : 'Pantalla completa',
                icon: Icon(
                    salir != null
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                ),
                onPressed: salir ?? expandir,
            ),
        );
    }

    Widget _barraProgreso(VideoPlayerValue value) {
        final duracionMs = value.duration.inMilliseconds;
        final posicionMs = value.position.inMilliseconds;

        return Slider(
            value: duracionMs == 0
                ? 0
                : (posicionMs > duracionMs ? duracionMs : posicionMs).toDouble(),
            max: duracionMs == 0 ? 1 : duracionMs.toDouble(),
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (valor) => widget.controller
                .seekTo(Duration(milliseconds: valor.toInt())),
        );
    }

    Widget _filaReproduccion(VideoPlayerValue value) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                IconButton(
                    color: Colors.white,
                    tooltip: 'Retroceder 10 s',
                    icon: const Icon(Icons.replay_10),
                    onPressed: () => _saltar(const Duration(seconds: -10)),
                ),
                IconButton(
                    color: Colors.white,
                    iconSize: 44,
                    icon: Icon(
                        value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                    ),
                    onPressed: () => value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play(),
                ),
                IconButton(
                    color: Colors.white,
                    tooltip: 'Avanzar 10 s',
                    icon: const Icon(Icons.forward_10),
                    onPressed: () => _saltar(const Duration(seconds: 10)),
                ),
            ],
        );
    }
}
