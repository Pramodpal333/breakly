import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle local storage of user preferences.
///
/// Wraps [SharedPreferences] to provide a clean API for checking and updating
/// onboarding status.
class PreferencesService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _locationPreferenceKey = 'location_preference';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Checks if the user has completed the onboarding flow.
  bool get isOnboardingCompleted =>
      _prefs.getBool(_onboardingCompletedKey) ?? false;

  /// Marks the onboarding flow as completed.
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompletedKey, true);
  }

  /// Gets the stored location preference. Defaults to 'anywhere' if not set.
  String getLocationPreference() {
    return _prefs.getString(_locationPreferenceKey) ?? 'anywhere';
  }

  /// Sets the location preference.
  /// Values: 'office', 'home', 'anywhere'
  Future<void> setLocationPreference(String value) async {
    await _prefs.setString(_locationPreferenceKey, value);
  }

  /// Logs out the user by clearing all preferences.
  Future<void> logout() async {
    await _prefs.clear();
  }

  static const String _lastFocusDurationKey = 'last_focus_duration';

  /// Gets the last saved focus duration in minutes. Defaults to 30.
  int getLastFocusDuration() {
    return _prefs.getInt(_lastFocusDurationKey) ?? 30;
  }

  /// Saves the focus duration preference in minutes.
  Future<void> saveLastFocusDuration(int minutes) async {
    await _prefs.setInt(_lastFocusDurationKey, minutes);
  }
}
