// FICHA DE UN CONTENIDO DE UDITFLIX
// Vista de detalle con cartelera, acciones principales y metadatos,
// siguiendo el estilo de las fichas de las plataformas de streaming.

import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';
import 'arcade_screen.dart';
import 'reproductor_screen.dart';

class FichaScreen extends StatelessWidget {
    const FichaScreen({super.key, required this.contenido});

    final Contenido contenido;

    void _abrirReproductor(BuildContext context) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => ReproductorScreen(contenido: contenido),
            ),
        );
    }

    void _abrirArcade(BuildContext context) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ArcadeScreen()),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text(contenido.titulo)),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        _Portada(
                            contenido: contenido,
                            onReproducir: () => _abrirReproductor(context),
                            onArcade: () => _abrirArcade(context),
                        ),
                        Center(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 900),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 8, 20, 40),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                                'Sinopsis',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                            ),
                                            const SizedBox(height: 12),
                                            ConstrainedBox(
                                                constraints: const BoxConstraints(
                                                    maxWidth: 720),
                                                child: Text(
                                                    contenido.descripcion,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(height: 1.7),
                                                ),
                                            ),
                                            const SizedBox(height: 32),
                                            Text(
                                                'Detalles',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                            ),
                                            const SizedBox(height: 14),
                                            _Detalle(
                                                icono: Icons.category_outlined,
                                                etiqueta: 'Categoría',
                                                valor: contenido.tipo,
                                            ),
                                            const SizedBox(height: 10),
                                            const _Detalle(
                                                icono: Icons.devices_outlined,
                                                etiqueta: 'Disponible en',
                                                valor:
                                                    'Web, móvil y escritorio',
                                            ),
                                            const SizedBox(height: 28),
                                            SizedBox(
                                                width: 220,
                                                child: OutlinedButton.icon(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    icon: const Icon(
                                                        Icons.arrow_back),
                                                    label: const Text(
                                                        'Volver al catálogo'),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _Detalle extends StatelessWidget {
    const _Detalle({
        required this.icono,
        required this.etiqueta,
        required this.valor,
    });

    final IconData icono;
    final String etiqueta;
    final String valor;

    @override
    Widget build(BuildContext context) {
        return Row(
            children: [
                Icon(icono, size: 18, color: AppColors.muted),
                const SizedBox(width: 12),
                Text(
                    '$etiqueta: ',
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 14),
                ),
                Expanded(
                    child: Text(
                        valor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                ),
            ],
        );
    }
}

class _Portada extends StatelessWidget {
    const _Portada({
        required this.contenido,
        required this.onReproducir,
        required this.onArcade,
    });

    final Contenido contenido;
    final VoidCallback onReproducir;
    final VoidCallback onArcade;

    @override
    Widget build(BuildContext context) {
        return LayoutBuilder(
            builder: (context, constraints) {
                final compacto = constraints.maxWidth < 600;

                return Container(
                    height: compacto ? 400 : 470,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF42090D), Color(0xFF0A0A0A)],
                        ),
                    ),
                    child: Stack(
                        children: [
                            Positioned(
                                right: compacto ? -70 : 60,
                                top: compacto ? 26 : 40,
                                child: _Arte(
                                    icono: _icono(contenido.tipo),
                                    compacto: compacto,
                                ),
                            ),
                            const Positioned.fill(
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                                Color(0xF00A0A0A),
                                                Color(0x880A0A0A),
                                                Color(0x220A0A0A),
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                            const Positioned.fill(
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                                Colors.transparent,
                                                Color(0x440A0A0A),
                                                Color(0xFF0A0A0A),
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            compacto ? 20 : 48, 20, 20, 24),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                const Text(
                                                    'UDITFLIX ORIGINAL',
                                                    style: TextStyle(
                                                        color: AppColors.primary,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        letterSpacing: 2,
                                                    ),
                                                ),
                                                const SizedBox(height: 10),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: compacto
                                                            ? double.infinity
                                                            : 620),
                                                    child: Text(
                                                        contenido.titulo,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: compacto
                                                                ? 34
                                                                : 50,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            height: 1.05,
                                                            letterSpacing: -1.4,
                                                        ),
                                                    ),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                    children: [
                                                        const Icon(
                                                            Icons.star,
                                                            size: 15,
                                                            color: AppColors
                                                                .amber,
                                                        ),
                                                        const SizedBox(width: 6),
                                                        const Text(
                                                            'Destacado',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .muted,
                                                                fontSize: 13,
                                                            ),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                            contenido.tipo,
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .muted,
                                                                fontSize: 13,
                                                            ),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                            child: Text(
                                                                contenido
                                                                    .duracion,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .muted,
                                                                    fontSize:
                                                                        13,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                const SizedBox(height: 20),
                                                if (contenido.urlVideo != null)
                                                    SizedBox(
                                                        width: 230,
                                                        child: FilledButton.icon(
                                                            onPressed:
                                                                onReproducir,
                                                            icon: const Icon(
                                                                Icons.play_arrow),
                                                            label: const Text(
                                                                'Reproducir vídeo'),
                                                        ),
                                                    ),
                                                if (contenido.tipo == 'Juego') ...[
                                                    const SizedBox(height: 10),
                                                    SizedBox(
                                                        width: 230,
                                                        child: FilledButton.icon(
                                                            onPressed: onArcade,
                                                            icon: const Icon(
                                                                Icons
                                                                    .sports_esports),
                                                            label: const Text(
                                                                'Abrir UDIT Arcade'),
                                                        ),
                                                    ),
                                                ],
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                );
            },
        );
    }

    IconData _icono(String tipo) => switch (tipo) {
        'Video' => Icons.play_circle_fill,
        'Cómic' => Icons.auto_stories,
        'Juego' => Icons.sports_esports,
        _ => Icons.play_circle_fill,
    };
}

class _Arte extends StatelessWidget {
    const _Arte({required this.icono, required this.compacto});

    final IconData icono;
    final bool compacto;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: compacto ? 220 : 360,
            height: compacto ? 260 : 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B1A1F), Color(0xFF151515)],
                ),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 40,
                        offset: const Offset(-10, 18),
                    ),
                ],
            ),
            child: Icon(icono,
                size: compacto ? 100 : 150, color: const Color(0x44FFFFFF)),
        );
    }
}
