// CATÁLOGO DE UDITFLIX
// Pantalla de inicio inspirada en plataformas de streaming: cartelera
// destacada, navegación superior, filas de contenido y accesos al arcade.

import 'package:flutter/material.dart';

import '../data/contenidos.dart';
import '../models/contenido.dart';
import '../theme/app_theme.dart';
import 'arcade_screen.dart';
import 'ficha_screen.dart';
import 'reproductor_screen.dart';

class CatalogoScreen extends StatefulWidget {
    const CatalogoScreen({super.key});

    @override
    State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
    static const _filtros = [
        MapEntry('Todos', 'Todos'),
        MapEntry('Vídeos', 'Video'),
        MapEntry('Cómics', 'Cómic'),
        MapEntry('Juegos', 'Juego'),
    ];

    static const _categorias = [
        _Categoria('Vídeos', 'Video', Icons.play_circle_fill),
        _Categoria('Cómics', 'Cómic', Icons.auto_stories),
        _Categoria('Juegos', 'Juego', Icons.sports_esports),
    ];

    String _filtro = 'Todos';

    List<Contenido> get _contenidosVisibles => _filtro == 'Todos'
        ? contenidos
        : contenidos.where((c) => c.tipo == _filtro).toList();

    void _abrirArcade(BuildContext context) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ArcadeScreen()),
        );
    }

    void _abrirFicha(BuildContext context, Contenido contenido) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => FichaScreen(contenido: contenido)),
        );
    }

    void _abrirReproductor(BuildContext context) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => ReproductorScreen(contenido: contenidos.first),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        final visibles = _contenidosVisibles;

        return Scaffold(
            appBar: AppBar(
                flexibleSpace: const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF0A0A0A), Colors.transparent],
                        ),
                    ),
                ),
                title: LayoutBuilder(
                    builder: (context, constraints) {
                        return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                const Text(
                                    'UDITflix',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1.5,
                                    ),
                                ),
                                if (constraints.maxWidth > 520)
                                    for (final enlace in _filtros)
                                        TextButton(
                                            onPressed: () => setState(
                                                () => _filtro = enlace.value,
                                            ),
                                            child: Text(
                                                enlace.key,
                                                style: TextStyle(
                                                    color: _filtro ==
                                                            enlace.value
                                                        ? AppColors.text
                                                        : AppColors.muted,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                ),
                                            ),
                                        ),
                            ],
                        );
                    },
                ),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.sports_esports),
                        tooltip: 'UDIT Arcade',
                        onPressed: () => _abrirArcade(context),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 16, left: 4),
                        child: Tooltip(
                            message: 'Perfil',
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                    'U',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                    ),
                                ),
                            ),
                        ),
                    ),
                ],
            ),
            body: SafeArea(
                child: CustomScrollView(
                    slivers: [
                        SliverToBoxAdapter(
                            child: _Cartelera(
                                onReproducir: () => _abrirReproductor(context),
                                onMasInformacion: () => _abrirFicha(
                                    context, contenidos.first),
                            ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: const SliverToBoxAdapter(
                                child: _TituloSeccion('Tendencias ahora'),
                            ),
                        ),
                        SliverToBoxAdapter(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 12, 20, 4),
                                child: Wrap(
                                    spacing: 8,
                                    children: [
                                        for (final filtro in _filtros)
                                            ChoiceChip(
                                                label: Text(filtro.key),
                                                selected:
                                                    _filtro == filtro.value,
                                                showCheckmark: false,
                                                onSelected: (_) => setState(
                                                    () => _filtro =
                                                        filtro.value,
                                                ),
                                            ),
                                    ],
                                ),
                            ),
                        ),
                        SliverToBoxAdapter(
                            child: SizedBox(
                                height: 250,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 16, 20, 8),
                                    itemCount: visibles.length,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, index) =>
                                        _TarjetaContenido(
                                            contenido: visibles[index],
                                            posicion: index + 1,
                                            onTap: () => _abrirFicha(
                                                context, visibles[index]),
                                        ),
                                ),
                            ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: const SliverToBoxAdapter(
                                child: _TituloSeccion('Explora por tipo'),
                            ),
                        ),
                        SliverToBoxAdapter(
                            child: SizedBox(
                                height: 92,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 14, 20, 8),
                                    itemCount: _categorias.length,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                        final categoria = _categorias[index];
                                        return _BotonCategoria(
                                            categoria: categoria,
                                            seleccionada:
                                                _filtro == categoria.valor,
                                            onTap: () => setState(
                                                () => _filtro =
                                                    categoria.valor,
                                            ),
                                        );
                                    },
                                ),
                            ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: const SliverToBoxAdapter(
                                child: _TituloSeccion('UDIT Arcade'),
                            ),
                        ),
                        SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                                20, 12, 20, 20),
                            sliver: SliverToBoxAdapter(
                                child: _BannerArcade(
                                    onTap: () => _abrirArcade(context),
                                ),
                            ),
                        ),
                        const SliverToBoxAdapter(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 8, 20, 32),
                                child: Text(
                                    'UDITflix · Contenido de demostración',
                                    style: TextStyle(
                                        color: Color(0xFF6B6B6B), fontSize: 11),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _Categoria {
    const _Categoria(this.etiqueta, this.valor, this.icono);

    final String etiqueta;
    final String valor;
    final IconData icono;
}

class _Cartelera extends StatelessWidget {
    const _Cartelera({required this.onReproducir, required this.onMasInformacion});

    final VoidCallback onReproducir;
    final VoidCallback onMasInformacion;

    @override
    Widget build(BuildContext context) {
        return LayoutBuilder(
            builder: (context, constraints) {
                final compacto = constraints.maxWidth < 600;

                return Container(
                    height: compacto ? 420 : 440,
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
                                right: compacto ? -80 : 48,
                                top: compacto ? 30 : 28,
                                child: _ArteDestacado(compacto: compacto),
                            ),
                            const Positioned.fill(
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                                Color(0xF50A0A0A),
                                                Color(0x990A0A0A),
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
                                                Color(0x550A0A0A),
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
                                            compacto ? 20 : 48, 20, 20, 28),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                const Row(
                                                    children: [
                                                        Icon(
                                                            Icons
                                                                .local_fire_department,
                                                            size: 17,
                                                            color: AppColors
                                                                .primary,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                            'TOP 10 EN UDITFLIX',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .primary,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                letterSpacing:
                                                                    2,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                    'Aprende, crea y diviértete',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            compacto ? 34 : 52,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        height: 1.05,
                                                        letterSpacing: -1.5,
                                                    ),
                                                ),
                                                const SizedBox(height: 10),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: compacto
                                                            ? double.infinity
                                                            : 480),
                                                    child: const Text(
                                                        'Cursos, cómics y arcade en un solo lugar. '
                                                        'Descubre algo nuevo hoy.',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFE5E5E5),
                                                            fontSize: 14,
                                                            height: 1.4,
                                                        ),
                                                    ),
                                                ),
                                                const SizedBox(height: 18),
                                                Row(
                                                    children: [
                                                        SizedBox(
                                                            width: compacto
                                                                ? 140
                                                                : 175,
                                                            child: FilledButton.icon(
                                                                onPressed:
                                                                    onReproducir,
                                                                icon: const Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    size: 20),
                                                                label: const Text(
                                                                    'Reproducir'),
                                                                style: FilledButton
                                                                    .styleFrom(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            12),
                                                                ),
                                                            ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        SizedBox(
                                                            width: compacto
                                                                ? 160
                                                                : 195,
                                                            child: OutlinedButton
                                                                .icon(
                                                                onPressed:
                                                                    onMasInformacion,
                                                                icon: const Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 19),
                                                                label: const Text(
                                                                    'Más información'),
                                                                style: OutlinedButton
                                                                    .styleFrom(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            12),
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
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
}

class _ArteDestacado extends StatelessWidget {
    const _ArteDestacado({required this.compacto});

    final bool compacto;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: compacto ? 230 : 390,
            height: compacto ? 250 : 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF991B1B), Color(0xFF111827)],
                ),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 40,
                        offset: const Offset(-10, 20),
                    ),
                ],
            ),
            child: Stack(
                alignment: Alignment.center,
                children: [
                    Icon(Icons.play_circle_fill,
                        size: compacto ? 110 : 170,
                        color: const Color(0x33FFFFFF)),
                    const Positioned(
                        left: 22,
                        bottom: 22,
                        child: Icon(Icons.auto_stories,
                            size: 42, color: Color(0x66FFFFFF)),
                    ),
                    const Positioned(
                        right: 22,
                        top: 22,
                        child: Icon(Icons.sports_esports,
                            size: 42, color: Color(0x66FFFFFF)),
                    ),
                ],
            ),
        );
    }
}

class _TituloSeccion extends StatelessWidget {
    const _TituloSeccion(this.titulo);

    final String titulo;

    @override
    Widget build(BuildContext context) {
        return Row(
            children: [
                Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                    ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        titulo,
                        style: Theme.of(context).textTheme.headlineSmall,
                    ),
                ),
            ],
        );
    }
}

class _TarjetaContenido extends StatelessWidget {
    const _TarjetaContenido({
        required this.contenido,
        required this.posicion,
        required this.onTap,
    });

    final Contenido contenido;
    final int posicion;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        final tema = Theme.of(context);

        return SizedBox(
            width: 226,
            child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                    onTap: onTap,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            Container(
                                height: 126,
                                decoration: BoxDecoration(
                                    gradient: _degradado(contenido.tipo),
                                ),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                        Icon(_icono(contenido.tipo),
                                            size: 52,
                                            color: const Color(0xAAFFFFFF)),
                                        Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                    '$posicion',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            contenido.tipo.toUpperCase(),
                                            style: const TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.2,
                                            ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                            contenido.titulo,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: tema.textTheme.titleMedium
                                                ?.copyWith(fontSize: 15),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                            children: [
                                                const Icon(Icons.schedule,
                                                    size: 13,
                                                    color: AppColors.muted),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                    child: Text(
                                                        contenido.duracion,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: tema.textTheme
                                                            .bodySmall,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    IconData _icono(String tipo) => switch (tipo) {
        'Video' => Icons.play_circle_fill,
        'Cómic' => Icons.auto_stories,
        'Juego' => Icons.sports_esports,
        _ => Icons.play_circle_fill,
    };

    LinearGradient _degradado(String tipo) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3F3F46), Color(0xFF111111)],
    );
}

class _BotonCategoria extends StatelessWidget {
    const _BotonCategoria({
        required this.categoria,
        required this.seleccionada,
        required this.onTap,
    });

    final _Categoria categoria;
    final bool seleccionada;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: 175,
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                        color: seleccionada
                            ? const Color(0xFF3A1215)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: seleccionada
                                ? AppColors.primary
                                : AppColors.outline,
                        ),
                    ),
                    child: Row(
                        children: [
                            Icon(categoria.icono,
                                color: seleccionada
                                    ? AppColors.primary
                                    : AppColors.muted),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(
                                    categoria.etiqueta,
                                    style: TextStyle(
                                        color: seleccionada
                                            ? Colors.white
                                            : AppColors.muted,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

class _BannerArcade extends StatelessWidget {
    const _BannerArcade({required this.onTap});

    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF4C0B10), Color(0xFF141414)],
                    ),
                    border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                    children: [
                        Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.sports_esports,
                                color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        '¿Aceptas el reto?',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                        ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                        'Esquiva los tubos y supera tu récord en UDIT Arcade.',
                                        style: TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 12,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        const Icon(Icons.play_arrow, color: Colors.white),
                    ],
                ),
            ),
        );
    }
}
