import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freerasp/freerasp.dart';

import 'package:breakly/features/security/screens/security_alert_screen.dart';
import 'package:flutter/material.dart';

// Global access to Navigator for callbacks
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SecurityService {
  Future<void> init() async {
    // 1. Skip checks in Debug Mode
    if (kDebugMode) {
      debugPrint('[Security] Debug mode detected. Skipping FreeRASP init.');
      return;
    }

    try {
      // 2. Load Env (Should be loaded in main, but ensuring here)
      // Note: dotenv.load is typically called in main.

      // 3. Configure Talsec
      final config = TalsecConfig(
        androidConfig: AndroidConfig(
          packageName: 'com.pal.dev.breakly',
          signingCertHashes: [dotenv.get('ANDROID_SIGNING_HASH', fallback: '')],
          supportedStores: ['com.android.vending'], // Play Store
        ),
        iosConfig: IOSConfig(
          bundleIds: [
            dotenv.get('IOS_BUNDLE_ID', fallback: 'com.pal.dev.breakly'),
          ],
          teamId: '', // Optional for now
        ),
        watcherMail: dotenv.get('WATCHER_MAIL', fallback: 'alert@example.com'),
        isProd: true,
      );

      // 4. Start Talsec
      final callback = ThreatCallback(
        onAppIntegrity: () => _handleThreat('App Integrity Issue'),
        onObfuscationIssues: () => _handleThreat('Obfuscation Issue'),
        onDebug: () => _handleThreat('Debugger Detected'),
        onDeviceBinding: () => _handleThreat('Device Binding Issue'),
        onDeviceID: () => _handleThreat('Device ID Issue'),
        onHooks: () => _handleThreat('Hooks Detected'),
        onPrivilegedAccess: () =>
            _handleThreat('Privileged Access (Root/Jailbreak)'),
        onSecureHardwareNotAvailable: () =>
            _handleThreat('Secure Hardware Not Available'),
        onSimulator: () => _handleThreat('Simulator/Emulator Detected'),
        onUnofficialStore: () => _handleThreat('Unofficial Store'),
      );

      Talsec.instance.start(config);
      Talsec.instance.attachListener(callback);
      debugPrint('[Security] FreeRASP initialized and listening.');
    } catch (e) {
      debugPrint('[Security] Error initializing FreeRASP: $e');
    }
  }

  void _handleThreat(String reason) {
    debugPrint('[Security] Threat Detected: $reason');
    // Navigate to Alert Screen
    // using the global navigator key to ensure context access
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SecurityAlertScreen()),
        (route) => false,
      );
    }
  }
}
