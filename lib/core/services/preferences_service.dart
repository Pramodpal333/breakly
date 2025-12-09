import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle local storage of user preferences.
///
/// Wraps [SharedPreferences] to provide a clean API for checking and updating
/// onboarding status.
class PreferencesService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Checks if the user has completed the onboarding flow.
  bool get isOnboardingCompleted =>
      _prefs.getBool(_onboardingCompletedKey) ?? false;

  /// Marks the onboarding flow as completed.
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompletedKey, true);
  }
}
