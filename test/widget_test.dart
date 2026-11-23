// Pruebas básicas de la navegación y del minijuego de UDITflix.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uditflix/data/contenidos.dart';
import 'package:uditflix/main.dart';
import 'package:uditflix/screens/arcade_screen.dart';
import 'package:uditflix/screens/ficha_screen.dart';

void main() {
    testWidgets('el catálogo muestra los contenidos y el acceso a Arcade',
        (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());

        expect(find.text('UDITflix'), findsOneWidget);
        expect(find.text('Introducción a Flutter'), findsOneWidget);
        expect(find.byTooltip('UDIT Arcade'), findsOneWidget);
    });

    testWidgets('al pulsar un vídeo se abre su ficha con el botón de reproducir',
        (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());

        await tester.ensureVisible(find.text('Introducción a Flutter'));
        await tester.pump();
        await tester.tap(find.text('Introducción a Flutter'));
        await tester.pumpAndSettle();

        expect(find.text('15 minutos'), findsOneWidget);
        expect(find.text('Reproducir vídeo'), findsOneWidget);
    });

    testWidgets('la ficha de un juego enlaza con UDIT Arcade',
        (WidgetTester tester) async {
        await tester.pumpWidget(
            MaterialApp(home: FichaScreen(contenido: contenidos.last)),
        );

        expect(find.text('Abrir UDIT Arcade'), findsOneWidget);
    });

    testWidgets('la interfaz no desborda en una pantalla pequeña',
        (WidgetTester tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(const MyApp());

        expect(tester.takeException(), isNull);
    });

    testWidgets('la ficha no desborda en una pantalla pequeña',
        (WidgetTester tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(const MyApp());
        await tester.ensureVisible(find.text('Introducción a Flutter'));
        await tester.pump();
        await tester.tap(find.text('Introducción a Flutter'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
    });

    testWidgets('el arcade empieza en la pantalla de inicio',
        (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: ArcadeScreen()));

        expect(find.text('¿Listo para volar?'), findsOneWidget);
        expect(find.text('Empezar'), findsOneWidget);
    });

    test('los contenidos de vídeo tienen una URL HTTPS configurada', () {
        final videos = contenidos.where((c) => c.tipo == 'Video');
        expect(videos, isNotEmpty);
        expect(
            videos.every(
                (c) => c.urlVideo != null && c.urlVideo!.startsWith('https://'),
            ),
            isTrue,
        );
    });
}
