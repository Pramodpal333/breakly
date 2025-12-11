import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_util.dart';
import '../../../../core/widgets/smooth_container.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/preferences_service.dart';
import '../../home/screens/home_page.dart';

class PreferenceScreen extends StatefulWidget {
  final bool isEditMode;

  const PreferenceScreen({super.key, this.isEditMode = false});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String _selectedLocation = 'office'; // Default selection

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _selectedLocation = sl<PreferencesService>().getLocationPreference();
    }
  }

  Future<void> _saveAndContinue() async {
    // Save preference
    await sl<PreferencesService>().setLocationPreference(_selectedLocation);

    if (widget.isEditMode) {
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    // Mark onboarding as complete mostly happens here effectively
    // But we already marked ONBOARDING skipped logic in previous screen if skipped
    // If we came from "Get Started", we should ensure onboarding is marked complete here too
    // But to be safe let's just complete onboarding now.
    await sl<PreferencesService>().completeOnboarding();

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: widget.isEditMode
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  HapticUtil.feedback();
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                "Where will you primarily use Breakly?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "We'll tailor your activity suggestions based on your environment.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Office Option
              _buildOptionCard(
                title: "Office",
                description:
                    "Discreet stretches & movements suitable for a workspace.",
                icon: Icons.business,
                value: 'office',
                theme: theme,
              ),
              const SizedBox(height: 16),

              // Home Option
              _buildOptionCard(
                title: "Home",
                description: "Full range of motion. No one is watching!",
                icon: Icons.home,
                value: 'home',
                theme: theme,
              ),
              const SizedBox(height: 16),

              // Anywhere Option
              _buildOptionCard(
                title: "Anywhere",
                description: "A mix of everything. Surprise me!",
                icon: Icons.place,
                value: 'anywhere',
                theme: theme,
              ),

              const Spacer(),

              SmoothButton(
                onPressed: _saveAndContinue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(widget.isEditMode ? "SAVE" : "SAVE & CONTINUE"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required String value,
    required ThemeData theme,
  }) {
    final isSelected = _selectedLocation == value;
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final backgroundColor = isSelected
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : Colors.transparent;

    return GestureDetector(
      onTap: () {
        HapticUtil.feedback();
        setState(() {
          _selectedLocation = value;
        });
      },
      child: SmoothContainer(
        padding: const EdgeInsets.all(16),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // if (isSelected)
            //   Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
