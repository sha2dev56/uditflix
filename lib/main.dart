// Punto de entrada de la aplicación UDITflix.

import 'package:flutter/material.dart';

import 'screens/catalogo_screen.dart';
import 'theme/app_theme.dart';

void main() {
    runApp(const MyApp());
}

/// Widget principal: aplica el tema global y muestra el catálogo.
class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'UDITflix',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: const CatalogoScreen(),
        );
    }
}
