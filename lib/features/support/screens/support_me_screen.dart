import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/smooth_container.dart';

class SupportMeScreen extends StatelessWidget {
  const SupportMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming dark theme based on previous context, but using Theme.of just in case
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text("Support Me"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon or Illustration
            Center(
              child: SmoothContainer(
                width: 100,
                height: 100,
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 50,
                  color: Colors.amber,
                ),
              ),
            ),
            const Gap(32),

            // Main Message
            Text(
              "Hi there! 👋",
              style: AppTextStyles.headlineMedium.bold,
              textAlign: TextAlign.center,
            ),
            const Gap(24),

            SmoothContainer(
              padding: const EdgeInsets.all(24),
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  Text(
                    "Why Breakly?",
                    style: AppTextStyles.titleLarge.bold.copyWith(
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(16),
                  Text(
                    "If you work a desk job, you know the struggle. Sitting for long hours can take a toll on your health in the long run. I built Breakly to help you—and myself—remember to step away, stretch, and breathe.",
                    style: AppTextStyles.bodyLarge.regular.copyWith(
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const Gap(16),
                  Text(
                    "It's a small reminder for a big difference in your well-being.",
                    style: AppTextStyles.bodyLarge.medium.copyWith(height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const Gap(24),

            // Developer Effort & Ad-free
            SmoothContainer(
              padding: const EdgeInsets.all(24),
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
              child: Column(
                children: [
                  const Icon(Icons.block, color: Colors.greenAccent, size: 32),
                  const Gap(12),
                  Text(
                    "100% Free & No Ads",
                    style: AppTextStyles.titleMedium.bold.copyWith(
                      color: Colors.greenAccent,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    "I've put a lot of effort into making this app clean, beautiful, and distinctively yours. I decided to keep it completely free and without ads because I believe health shouldn't be interrupted.",
                    style: AppTextStyles.bodyMedium.regular.copyWith(
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Gap(32),

            // Call to Action (Support)
            Text(
              "If you enjoy using Breakly and want to support my work, considered showing some love!",
              style: AppTextStyles.bodyMedium.medium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const Gap(24),

            // Placeholder for actual support link/button (e.g. Buy Me A Coffee)
            // For now, just a thank you button or maybe a mock action
            SmoothButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Thank you for your support! ❤️"),
                  ),
                );
              },
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.coffee_rounded, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Buy me a coffee",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
