import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/services/preferences_service.dart';
import 'features/home/screens/home_page.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/security/screens/security_alert_screen.dart';

import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:store_checker/store_checker.dart';

// ---------------------------------------------------------------------------
// MAIN ENTRY POINT
// ---------------------------------------------------------------------------

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/security/services/security_service.dart';

// ---------------------------------------------------------------------------
// MAIN ENTRY POINT
// ---------------------------------------------------------------------------

Future<void> main() async {
  // Ensure widgets are bound before running
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Environment Variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found.");
  }

  // 2. Initialize Dependency Injection
  await setupLocator();

  // 3. Security: Installer Check (Pre-existing)
  final isSecureInstaller = await _checkInstallerSource();

  // 4. Security: FreeRASP Initialization
  final securityService = SecurityService();
  await securityService.init();

  // Lock orientation to portrait for MVP simplicity
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(BreaklyApp(isSecure: isSecureInstaller));
}

/// Checks if the app was installed from a valid store (Play Store or App Store).
/// Returns true if valid or in debug mode. Returns false if unauthorized.
Future<bool> _checkInstallerSource() async {
  if (kDebugMode) {
    // In debug mode, we allow running from any source (e.g., IDE, ADB).
    return true;
  }

  final source = await StoreChecker.getSource;

  // List of allowed sources
  const allowedSources = [
    Source.IS_INSTALLED_FROM_PLAY_STORE,
    Source.IS_INSTALLED_FROM_APP_STORE,
  ];

  return allowedSources.contains(source);
}

// ---------------------------------------------------------------------------
// APP CONFIGURATION
// ---------------------------------------------------------------------------

class BreaklyApp extends StatelessWidget {
  final bool isSecure;

  const BreaklyApp({super.key, required this.isSecure});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breakly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (!isSecure) {
      return const SecurityAlertScreen();
    }

    return sl<PreferencesService>().isOnboardingCompleted
        ? const HomePage()
        : const OnboardingScreen();
  }
}
