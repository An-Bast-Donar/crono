import 'package:crono/config/theme/app_theme.dart';
import 'package:crono/pages/large_window_page.dart';
import 'package:crono/pages/small_window_page.dart';
import 'package:crono/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const String appTitle = 'Crono';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Inicializar el provider (singleton)
  ProjectProvider();

  // Iniciar con ventana grande: 1200x800
  await windowManager.setSize(const Size(1200, 800));
  await windowManager.center();
  await windowManager.show();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  // true = ventana pequeña, false = ventana grande
  bool _isSmallWindow = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  // Interceptar minimizar cuando estamos en ventana grande
  @override
  void onWindowMinimize() async {
    if (!_isSmallWindow) {
      // Prevenir el comportamiento por defecto
      await windowManager.restore();

      // Cambiar a ventana pequeña
      await _switchToSmallWindow();
    }
  }

  // Interceptar maximizar cuando estamos en ventana pequeña
  @override
  void onWindowMaximize() async {
    if (_isSmallWindow) {
      // Prevenir el comportamiento por defecto
      await windowManager.unmaximize();

      // Cambiar a ventana grande
      await _switchToLargeWindow();
    }
  }

  Future<void> _switchToSmallWindow() async {
    setState(() {
      _isSmallWindow = true;
    });

    await windowManager.setAlwaysOnTop(true);
    await windowManager.setSize(const Size(250, 250));

    // Imprimir tamaño real de la ventana
    final size = await windowManager.getSize();
    debugPrint(
      'Tamaño real de ventana pequeña: ${size.width} x ${size.height}',
    );
  }

  Future<void> _switchToLargeWindow() async {
    setState(() {
      _isSmallWindow = false;
    });

    await windowManager.setAlwaysOnTop(false);
    await windowManager.setSize(const Size(1200, 800));

    // Imprimir tamaño real de la ventana
    final size = await windowManager.getSize();
    debugPrint('Tamaño real de ventana grande: ${size.width} x ${size.height}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _isSmallWindow ? const SmallWindowPage() : const LargeWindowPage(),
    );
  }
}
