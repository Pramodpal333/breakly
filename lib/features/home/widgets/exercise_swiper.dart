import 'package:breakly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../models/move_activity.dart';

class ExerciseSwiper extends StatelessWidget {
  final List<MoveActivity> activities;
  final VoidCallback onStartFocus;

  const ExerciseSwiper({
    super.key,
    required this.activities,
    required this.onStartFocus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If no activities, show a fallback
    if (activities.isEmpty) {
      return Center(
        child: Text("No tips available", style: theme.textTheme.bodyLarge),
      );
    }

    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            cardsCount: activities.length,
            numberOfCardsDisplayed: 3, // Stack effect
            backCardOffset: const Offset(0, 40), // Offset for stack depth
            padding: const EdgeInsets.all(24.0),
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
                  final activity = activities[index];
                  final color = _getRandomCalmColor(index);
                  return _buildCard(activity, theme, color);
                },
          ),
        ),
        const SizedBox(height: 24),
        // Custom Large Start Button
        SizedBox(
          width: 200,
          height: 60,
          child: FilledButton.icon(
            onPressed: onStartFocus,
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 4,
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text(
              "START FOCUS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Color _getRandomCalmColor(int index) {
    // List of darker, muted calm colors for better eye comfort
    final List<Color> colors = [
      const Color(0xFF4A6fa5), // Muted Blue
      const Color.fromARGB(255, 46, 85, 68), // Deep Sage
      const Color.fromARGB(255, 0, 84, 38), // Sage Green
      const Color.fromARGB(255, 24, 30, 45), // Slate Grey
      const Color.fromARGB(255, 73, 42, 31), // Brownish Grey
      const Color.fromARGB(255, 194, 52, 0), // Cocoa
      const Color.fromARGB(255, 14, 34, 45), // Blue Grey
      const Color.fromARGB(255, 0, 57, 83), // Teal Grey
      const Color.fromARGB(255, 52, 24, 90), // Teal Grey
      const Color.fromARGB(255, 73, 36, 36), // Teal Grey
    ];
    return colors[index % colors.length];
  }

  Widget _buildCard(
    MoveActivity activity,
    ThemeData theme,
    Color backgroundColor,
  ) {
    // Content is always white on these darker backgrounds
    const Color contentColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.2,
            ), // Slightly darker shadow
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15), // Subtle overlay
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, size: 64, color: contentColor),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              activity.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: contentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              activity.description,
              textAlign: TextAlign.center,
              // Increased font size by 2px as requested (16 + 2 = 18)
              style: theme.textTheme.bodyLarge?.copyWith(
                color: contentColor.withValues(alpha: 0.8),
                fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 16) + 2,
              ),
            ),
          ),
          if (activity.isStealth)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Chip(
                label: const Text("STEALTH MODE"),
                backgroundColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: contentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
