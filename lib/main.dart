import 'package:crono/config/theme/app_theme.dart';
import 'package:crono/pages/large_window_page.dart';
import 'package:crono/pages/small_window_page.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const String appTitle = 'Crono';

// Variable booleana para controlar qué ventana mostrar
// true = ventana pequeña, false = ventana grande
const bool isSmallWindow = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Configurar tamaño según el tipo de ventana
  if (isSmallWindow) {
    // Ventana pequeña: 250x250
    await windowManager.setSize(const Size(250, 250));
    await windowManager.setMinimumSize(const Size(250, 250));
    await windowManager.setMaximumSize(const Size(250, 250));
    await windowManager.setMaximizable(false); // Deshabilitar maximizar
    await windowManager.setAlwaysOnTop(true); // Siempre al frente
  } else {
    // Ventana grande: 1200x800
    await windowManager.setSize(const Size(1200, 800));
    await windowManager.setMinimumSize(const Size(600, 600));
  }

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

  @override
  void onWindowMinimize() {
    debugPrint('Se intentó minimizar la ventana');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: isSmallWindow ? const SmallWindowPage() : const LargeWindowPage(),
    );
  }
}
