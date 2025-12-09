import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/services/preferences_service.dart';
import 'features/home/screens/home_page.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

// ---------------------------------------------------------------------------
// MAIN ENTRY POINT
// ---------------------------------------------------------------------------

Future<void> main() async {
  // Ensure widgets are bound before running
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Dependency Injection
  await setupLocator();

  // Lock orientation to portrait for MVP simplicity
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: sl<PreferencesService>().isOnboardingCompleted
          ? const HomePage()
          : const OnboardingScreen(),
    );
  }
}
