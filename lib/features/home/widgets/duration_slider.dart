import 'package:flutter/material.dart';

class DurationSlider extends StatelessWidget {
  final double durationMinutes;
  final ValueChanged<double>? onChanged;
  final bool isEnabled;

  const DurationSlider({
    super.key,
    required this.durationMinutes,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Enhanced Label
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "Focus Duration",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "${durationMinutes.toInt()} min",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Custom Premium Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
            trackShape: const RoundedRectSliderTrackShape(),
            trackHeight: 12.0, // Chunky track
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 16.0,
              pressedElevation: 8.0,
            ),
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
            tickMarkShape: const RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: theme.colorScheme.primary,
            valueIndicatorTextStyle: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: durationMinutes,
            min: 1,
            max: 90,
            divisions: 89,
            label: "${durationMinutes.toInt()} min",
            onChanged: isEnabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
