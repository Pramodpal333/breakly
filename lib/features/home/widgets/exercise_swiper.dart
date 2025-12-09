import 'package:flutter/material.dart';
import '../models/move_activity.dart';

class ExerciseSwiper extends StatefulWidget {
  final List<MoveActivity> activities;
  final VoidCallback onStartFocus;

  const ExerciseSwiper({
    super.key,
    required this.activities,
    required this.onStartFocus,
  });

  @override
  State<ExerciseSwiper> createState() => _ExerciseSwiperState();
}

class _ExerciseSwiperState extends State<ExerciseSwiper> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.activities.length,
            itemBuilder: (context, index) {
              final activity = widget.activities[index];
              final isCurrent = index == _currentPage;

              // Scale animation for focus effect
              return AnimatedScale(
                scale: isCurrent ? 1.0 : 0.9,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
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
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.5,
                          ),
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
                            color: theme.colorScheme.onSecondaryContainer
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      if (activity.isStealth)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Chip(
                            label: const Text("STEALTH MODE"),
                            backgroundColor: theme.colorScheme.surface
                                .withValues(alpha: 0.5),
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Custom Large Start Button
        SizedBox(
          width: 200,
          height: 60,
          child: FilledButton.icon(
            onPressed: widget.onStartFocus,
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
}
