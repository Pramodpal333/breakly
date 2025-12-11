import 'package:breakly/core/services/version_service.dart';
import 'package:flutter/foundation.dart';
import 'package:store_checker/store_checker.dart';
import 'package:breakly/core/theme/app_colors.dart';
import 'package:breakly/core/theme/app_text_styles.dart';
import 'package:breakly/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/widgets/common_alert_bottom_sheet.dart';
import '../../../../core/widgets/smooth_container.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/preferences_service.dart';
import '../../onboarding/screens/preference_screen.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  late bool _vibrateOnAlert;
  late bool _playSoundOnAlert;
  late bool _ringInSilentMode;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    final prefs = sl<PreferencesService>();
    _vibrateOnAlert = prefs.vibrateOnAlert;
    _playSoundOnAlert = prefs.playSoundOnAlert;
    _ringInSilentMode = prefs.ringInSilentMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SmoothContainer(
      height: MediaQuery.of(context).size.height * 0.9,
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Column(
        children: [
          const Gap(12),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(16),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildSectionHeader(context, "Preferences"),
                const Gap(8),
                _buildOptionsContainer(
                  context,
                  children: [
                    _buildSwitchOption(
                      context,
                      title: 'Vibrate on Alert',
                      icon: Icons.vibration,
                      value: _vibrateOnAlert,
                      onChanged: (value) {
                        setState(() => _vibrateOnAlert = value);
                        sl<PreferencesService>().setVibrateOnAlert(value);
                      },
                    ),
                    _buildDivider(context),
                    _buildSwitchOption(
                      context,
                      title: 'Play Sound on Alert',
                      icon: Icons.volume_up_outlined,
                      value: _playSoundOnAlert,
                      onChanged: (value) {
                        setState(() => _playSoundOnAlert = value);
                        sl<PreferencesService>().setPlaySoundOnAlert(value);
                      },
                    ),
                    if (_playSoundOnAlert) ...[
                      _buildDivider(context),
                      _buildSwitchOption(
                        context,
                        title: 'Ring in Silent Mode',
                        icon: Icons.notifications_active_outlined,
                        value: _ringInSilentMode,
                        onChanged: (value) {
                          setState(() => _ringInSilentMode = value);
                          sl<PreferencesService>().setRingInSilentMode(value);
                        },
                      ),
                    ],
                  ],
                ),

                const Gap(32),

                _buildSectionHeader(context, "Work Environment"),
                const Gap(8),
                _buildOptionsContainer(
                  context,
                  children: [
                    _buildNavigationOption(
                      context,
                      title: 'Work Mode',
                      icon: Icons.work_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PreferenceScreen(isEditMode: true),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 40),
            child: _buildOptionsContainer(
              context,
              backgroundColor: AppColors.error2,
              borderColor: AppColors.error,
              children: [
                _buildNavigationOption(
                  context,
                  title: 'Logout',

                  icon: Icons.logout,
                  onTap: () {
                    showModalBottomSheet(
                      barrierColor: Colors.black87,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommonAlertBottomSheet(
                        title: "Logout",
                        subtitle:
                            "Are you sure you want to log out? Your current session progress will be saved.",
                        okayText: "Logout",
                        isDestructive: true,
                        icon: Icon(Icons.logout_rounded),
                        onOkay: () {
                          // Close the bottom sheet first
                          Navigator.pop(context);

                          // Perform logout
                          sl<PreferencesService>().logout();

                          // Navigate to onboarding
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                Text(
                  sl<VersionService>().appVersion,
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                ),
                if (kDebugMode) ...[
                  const Gap(4),
                  FutureBuilder<Source>(
                    future: StoreChecker.getSource,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Source: ${snapshot.data!.name}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildOptionsContainer(
    BuildContext context, {
    required List<Widget> children,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return SmoothContainer(
      color:
          backgroundColor ??
          Theme.of(
            context,
          ).colorScheme.secondaryContainer.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color:
            borderColor ??
            Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      endIndent: 16,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Widget _buildSwitchOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const Gap(16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
