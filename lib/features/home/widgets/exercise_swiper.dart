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
                  return _buildCard(activity, theme);
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

  Widget _buildCard(MoveActivity activity, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.icon,
              size: 64,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              activity.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ),
          if (activity.isStealth)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Chip(
                label: const Text("STEALTH MODE"),
                backgroundColor: theme.colorScheme.surface.withValues(
                  alpha: 0.5,
                ),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
