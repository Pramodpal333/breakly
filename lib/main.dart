import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_page.dart';

// ---------------------------------------------------------------------------
// MAIN ENTRY POINT
// ---------------------------------------------------------------------------

void main() {
  // Ensure widgets are bound before running
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Dependency Injection
  setupLocator();

  // Lock orientation to portrait for MVP simplicity
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const BreaklyApp());
}

// ---------------------------------------------------------------------------
// APP CONFIGURATION
// ---------------------------------------------------------------------------

class BreaklyApp extends StatelessWidget {
  const BreaklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breakly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
