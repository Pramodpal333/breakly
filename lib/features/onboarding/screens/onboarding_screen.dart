import 'package:breakly/core/theme/app_colors.dart';
import 'package:breakly/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_util.dart';

import '../../../../core/widgets/smooth_container.dart';
import 'preference_screen.dart';
import '../widgets/onboarding_page_content.dart';

/// Screen that manages the onboarding flow using a [PageView].
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    // DO NOT mark as complete yet. Pass to preference screen.
    // If user skips, we might want to go to Preference screen too or set defaults.
    // Let's assume SKIP also goes to Preference Screen for now to capture preference.

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PreferenceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                OnboardingPageContent(
                  title: 'Timed Focus Sessions',
                  description:
                      'Boost your productivity by working in focused 50-minute intervals. '
                      'Stay in the zone and accomplish more.',
                  icon: Icons.timer,
                  iconColor: theme.colorScheme.primary,
                ),
                OnboardingPageContent(
                  title: 'Active Breaks',
                  description:
                      'Get guided exercises during your breaks. '
                      'Swipe through tips to relieve eye strain and improve posture.',
                  icon: Icons.accessibility_new,
                  iconColor: const Color(0xFF6B9080), // Sage
                ),
                OnboardingPageContent(
                  title: 'Stay Healthy',
                  description:
                      'Regular movement prevents burnout and keeps your energy levels high. '
                      'Your health is your greatest asset.',
                  icon: Icons.favorite,
                  iconColor: const Color(0xFFE57373), // Soft Red
                ),
              ],
            ),

            // Skip Button (Top Right)
            if (_currentPage < _numPages - 1)
              Positioned(
                top: 16,
                right: 24,
                child: TextButton(
                  onPressed: () {
                    HapticUtil.feedback();
                    _completeOnboarding();
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),

            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicator
                  Row(
                    children: List.generate(
                      _numPages,
                      (index) => SmoothContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        color: index == _currentPage
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // Next / Get Started Button
                  SmoothButton(
                    onPressed: _onNext,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _currentPage == _numPages - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentPage == _numPages - 1
                              ? "GET STARTED"
                              : "NEXT",
                          style: AppTextStyles.bodyMedium.medium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
