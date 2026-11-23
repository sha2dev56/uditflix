// UDIT ARCADE
// Flappy Bird sencillo dibujado con Flutter (sin motores externos):
// el ave cae por gravedad, cada toque la impulsa y hay que esquivar tubos.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class ArcadeScreen extends StatelessWidget {
    const ArcadeScreen({super.key});

    static void _mostrarAyuda(BuildContext context) {
        showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                backgroundColor: AppColors.surface,
                title: Text(
                    'Cómo jugar',
                    style: Theme.of(context).textTheme.headlineSmall,
                ),
                content: const Text(
                    'Toca la pantalla o pulsa la barra espaciadora para '
                    'hacer saltar al ave. Esquiva los tubos y suma un punto '
                    'por cada uno que superes.',
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Entendido'),
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('UDIT Arcade'),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.help_outline),
                        tooltip: 'Cómo jugar',
                        onPressed: () => _mostrarAyuda(context),
                    ),
                ],
            ),
            body: const SafeArea(child: Center(child: _JuegoFlappy())),
        );
    }
}

class _JuegoFlappy extends StatefulWidget {
    const _JuegoFlappy();

    @override
    State<_JuegoFlappy> createState() => _JuegoFlappyState();
}

class _JuegoFlappyState extends State<_JuegoFlappy>
    with TickerProviderStateMixin {
    final _partida = _PartidaFlappy();
    final _foco = FocusNode();

    Ticker? _ticker;
    double? _instanteAnterior;

    @override
    void initState() {
        super.initState();
        _ticker = createTicker(_alTick)..start();
    }

    @override
    void dispose() {
        _ticker?.dispose();
        _foco.dispose();
        super.dispose();
    }

    void _alTick(Duration tiempo) {
        final segundos = tiempo.inMicroseconds / 1000000;
        final dt = _instanteAnterior == null
            ? 0.0
            : math.min(0.05, segundos - _instanteAnterior!).toDouble();
        _instanteAnterior = segundos;

        if (dt > 0 && _partida.estado == _Estado.enJuego) {
            _partida.actualizar(dt);
            setState(() {});
        }
    }

    void _volar() {
        final estadoAnterior = _partida.estado;
        _partida.volar();
        if (estadoAnterior != _partida.estado) setState(() {});
    }

    void _empezar() {
        setState(() => _partida.empezar());
    }

    void _onTecla(KeyEvent evento) {
        if (evento is! KeyDownEvent) return;
        final tecla = evento.logicalKey;
        if (tecla == LogicalKeyboardKey.space ||
            tecla == LogicalKeyboardKey.arrowUp ||
            tecla == LogicalKeyboardKey.keyW) {
            _volar();
        }
    }

    @override
    Widget build(BuildContext context) {
        return FittedBox(
            child: SizedBox(
                width: _PartidaFlappy.ancho,
                height: _PartidaFlappy.alto,
                child: KeyboardListener(
                    focusNode: _foco,
                    autofocus: true,
                    onKeyEvent: _onTecla,
                    child: GestureDetector(
                        onTapDown: (_) => _volar(),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.outline, width: 2),
                                boxShadow: const [
                                    BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 24,
                                        offset: Offset(0, 12),
                                    ),
                                ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                                children: [
                                    CustomPaint(
                                        painter: _Pintor(_partida),
                                        child: const SizedBox.expand(),
                                    ),
                                    if (_partida.estado == _Estado.listo)
                                        _PantallaInicio(onEmpezar: _empezar),
                                    if (_partida.estado == _Estado.finalizado)
                                        _PantallaFin(
                                            puntos: _partida.puntos,
                                            mejor: _partida.mejor,
                                            onReiniciar: _empezar,
                                        ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}

class _PantallaInicio extends StatelessWidget {
    const _PantallaInicio({required this.onEmpezar});

    final VoidCallback onEmpezar;

    @override
    Widget build(BuildContext context) {
        return Positioned.fill(
            child: Container(
                color: const Color(0xB3081020),
                alignment: Alignment.center,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                                color: Color(0x33FFFFFF),
                                shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.flight_takeoff,
                                size: 36, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                            '¿Listo para volar?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                            ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 36),
                            child: Text(
                                'Toca la pantalla o pulsa Espacio. '
                                'Evita los tubos para sumar puntos.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xD9FFFFFF), fontSize: 13),
                            ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                            width: 180,
                            child: FilledButton(
                                onPressed: onEmpezar,
                                child: const Text('Empezar'),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _PantallaFin extends StatelessWidget {
    const _PantallaFin({
        required this.puntos,
        required this.mejor,
        required this.onReiniciar,
    });

    final int puntos;
    final int mejor;
    final VoidCallback onReiniciar;

    @override
    Widget build(BuildContext context) {
        return Positioned.fill(
            child: Container(
                color: const Color(0xCC081020),
                alignment: Alignment.center,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const Text(
                            'Fin de la partida',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                            ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            _Puntuacion(
                                etiqueta: 'PUNTOS',
                                valor: '$puntos',
                                color: AppColors.amber,
                            ),
                            const SizedBox(width: 24),
                            _Puntuacion(
                                etiqueta: 'RÉCORD',
                                valor: '$mejor',
                                color: AppColors.secondary,
                            ),
                            ],
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                            width: 200,
                            child: FilledButton.icon(
                                onPressed: onReiniciar,
                                icon: const Icon(Icons.replay),
                                label: const Text('Jugar de nuevo'),
                            ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Volver al catálogo'),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _Puntuacion extends StatelessWidget {
    const _Puntuacion({
        required this.etiqueta,
        required this.valor,
        required this.color,
    });

    final String etiqueta;
    final String valor;
    final Color color;

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                Text(
                    etiqueta,
                    style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                    ),
                ),
                const SizedBox(height: 4),
                Text(
                    valor,
                    style: TextStyle(
                        color: color,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                    ),
                ),
            ],
        );
    }
}

enum _Estado { listo, enJuego, finalizado }

class _Tubo {
    _Tubo(this.x, this.centro);

    double x;
    final double centro;
    bool puntuado = false;
}

class _PartidaFlappy {
    static const ancho = 360.0;
    static const alto = 640.0;
    static const birdX = 100.0;
    static const radio = 17.0;
    static const anchoTubo = 64.0;
    static const hueco = 180.0;
    static const sueloY = 596.0;
    static const gravedad = 1150.0;
    static const impulso = -370.0;
    static const velocidadTubos = 155.0;
    static const intervalo = 1.7;

    final _aleatorio = math.Random();

    _Estado estado = _Estado.listo;
    double y = alto / 2;
    double velocidad = 0;
    double tiempoDesdeTubo = 0;
    int puntos = 0;
    int mejor = 0;
    final List<_Tubo> tubos = [];

    double get angulo => (velocidad / 620).clamp(-0.5, 1.2).toDouble();

    void empezar() {
        tubos.clear();
        y = alto / 2;
        velocidad = impulso;
        puntos = 0;
        // Primer tubo poco después de empezar para dar tiempo a reaccionar.
        tiempoDesdeTubo = intervalo - 0.6;
        estado = _Estado.enJuego;
    }

    void volar() {
        if (estado == _Estado.finalizado) return;
        if (estado == _Estado.listo) {
            empezar();
            return;
        }
        velocidad = impulso;
    }

    void actualizar(double dt) {
        velocidad += gravedad * dt;
        y += velocidad * dt;

        if (y - radio < 0) {
            y = radio;
            velocidad = 0;
        }
        if (y + radio >= sueloY) {
            _terminar();
            return;
        }

        tiempoDesdeTubo += dt;
        if (tiempoDesdeTubo >= intervalo) {
            tiempoDesdeTubo -= intervalo;
            final centro = hueco / 2 + 46 +
                _aleatorio.nextDouble() * (sueloY - hueco - 92);
            tubos.add(_Tubo(ancho + 20, centro));
        }

        final ave = Rect.fromLTWH(
            birdX - radio + 3, y - radio + 3, (radio - 3) * 2, (radio - 3) * 2);

        for (final tubo in tubos) {
            tubo.x -= velocidadTubos * dt;

            final superior = Rect.fromLTWH(
                tubo.x, 0, anchoTubo, tubo.centro - hueco / 2);
            final inferior = Rect.fromLTWH(
                tubo.x, tubo.centro + hueco / 2, anchoTubo,
                alto - tubo.centro - hueco / 2);

            if (ave.overlaps(superior) || ave.overlaps(inferior)) {
                _terminar();
                return;
            }

            if (!tubo.puntuado && tubo.x + anchoTubo < birdX) {
                tubo.puntuado = true;
                puntos++;
            }
        }

        tubos.removeWhere((tubo) => tubo.x + anchoTubo < -10);
    }

    void _terminar() {
        estado = _Estado.finalizado;
        mejor = math.max(mejor, puntos);
    }
}

class _Pintor extends CustomPainter {
    _Pintor(this.partida);

    final _PartidaFlappy partida;

    static const _nubes = [
        Offset(70, 110),
        Offset(250, 190),
        Offset(140, 300),
    ];

    @override
    void paint(Canvas canvas, Size size) {
        final area = Offset.zero & size;

        // Cielo.
        canvas.drawRect(
            area,
            Paint()
                ..shader = const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0EA5E9), Color(0xFF1E3A8A)],
                ).createShader(area),
        );

        // Sol y nubes decorativas.
        canvas.drawCircle(
            const Offset(296, 84),
            34,
            Paint()..color = const Color(0x40FFFFFF),
        );
        final nube = Paint()..color = const Color(0x2EFFFFFF);
        for (final centro in _nubes) {
            canvas.drawCircle(centro, 18, nube);
            canvas.drawCircle(centro + const Offset(18, 4), 22, nube);
            canvas.drawCircle(centro + const Offset(-18, 5), 15, nube);
        }

        // Tubos.
        for (final tubo in partida.tubos) {
            _dibujarTubo(
                canvas,
                Rect.fromLTWH(tubo.x, 0, _PartidaFlappy.anchoTubo,
                    tubo.centro - _PartidaFlappy.hueco / 2),
                inferior: false,
            );
            _dibujarTubo(
                canvas,
                Rect.fromLTWH(tubo.x, tubo.centro + _PartidaFlappy.hueco / 2,
                    _PartidaFlappy.anchoTubo,
                    _PartidaFlappy.alto - tubo.centro - _PartidaFlappy.hueco / 2),
                inferior: true,
            );
        }

        // Suelo.
        final suelo = Paint()..color = const Color(0xFF14213D);
        canvas.drawRect(
            Rect.fromLTWH(0, _PartidaFlappy.sueloY, size.width,
                size.height - _PartidaFlappy.sueloY),
            suelo,
        );
        final linea = Paint()
            ..color = const Color(0xFF34D399)
            ..strokeWidth = 4;
        canvas.drawLine(
            const Offset(0, _PartidaFlappy.sueloY),
            Offset(size.width, _PartidaFlappy.sueloY),
            linea,
        );

        _dibujarAve(canvas);

        if (partida.estado == _Estado.enJuego) {
            _dibujarTexto(
                canvas,
                '${partida.puntos}',
                Offset((size.width - 40) / 2, 32),
                56,
                Colors.white,
            );
        }
    }

    void _dibujarTubo(Canvas canvas, Rect rect, {required bool inferior}) {
        if (rect.height <= 0) return;

        final relleno = Paint()
            ..shader = const LinearGradient(
                colors: [Color(0xFF34D399), Color(0xFF047857)],
            ).createShader(rect);
        final cuerpo = RRect.fromRectAndRadius(
            rect.deflate(1), const Radius.circular(6));
        canvas.drawRRect(cuerpo, relleno);

        final tapa = inferior
            ? Rect.fromLTWH(rect.left - 4, rect.top, rect.width + 8, 22)
            : Rect.fromLTWH(rect.left - 4, rect.bottom - 22,
                rect.width + 8, 22);
        canvas.drawRRect(
            RRect.fromRectAndRadius(tapa, const Radius.circular(5)),
            relleno,
        );

        final brillo = Paint()..color = const Color(0x55FFFFFF);
        canvas.drawRect(
            Rect.fromLTWH(rect.left + 8, rect.top + 4, 7, rect.height - 8),
            brillo,
        );
    }

    void _dibujarAve(Canvas canvas) {
        canvas.save();
        canvas.translate(_PartidaFlappy.birdX, partida.y);
        canvas.rotate(partida.angulo);

        canvas.drawCircle(
            const Offset(2, 3),
            _PartidaFlappy.radio,
            Paint()..color = const Color(0x44000000),
        );
        canvas.drawCircle(
            Offset.zero,
            _PartidaFlappy.radio,
            Paint()..color = AppColors.amber,
        );
        canvas.drawOval(
            const Rect.fromLTWH(-13, 2, 18, 11),
            Paint()..color = const Color(0xFFFDE68A),
        );
        canvas.drawCircle(
            const Offset(7, -6),
            6,
            Paint()..color = Colors.white,
        );
        canvas.drawCircle(
            const Offset(9, -6),
            2.6,
            Paint()..color = const Color(0xFF0F172A),
        );
        final pico = Paint()..color = const Color(0xFFFB923C);
        final camino = Path()
            ..moveTo(15, -2)
            ..lineTo(27, 2)
            ..lineTo(15, 7)
            ..close();
        canvas.drawPath(camino, pico);
        canvas.restore();
    }

    void _dibujarTexto(
        Canvas canvas, String texto, Offset posicion, double tamano,
        Color color) {
        final pintor = TextPainter(
            text: TextSpan(
                text: texto,
                style: TextStyle(
                    color: color,
                    fontSize: tamano,
                    fontWeight: FontWeight.w800,
                    shadows: [
                        Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                        ),
                    ],
                ),
            ),
            textDirection: TextDirection.ltr,
        )..layout();
        pintor.paint(canvas, posicion);
    }

    @override
    bool shouldRepaint(covariant _Pintor oldDelegate) => true;
}
