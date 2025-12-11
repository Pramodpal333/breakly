import 'package:flutter/services.dart';

/// Utility for handling haptic feedback across the app.
class HapticUtil {
  /// Triggers a light impact haptic feedback.
  static Future<void> feedback() async {
    await HapticFeedback.mediumImpact();
  }

  /// Triggers a medium impact haptic feedback.
  static Future<void> mediumFeedback() async {
    await HapticFeedback.heavyImpact();
  }
}
