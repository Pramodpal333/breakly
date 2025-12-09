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
        Text(
          "Focus Duration: ${durationMinutes.toInt()} min",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            trackHeight: 6.0,
          ),
          child: Slider(
            value: durationMinutes,
            min: 5,
            max: 90,
            divisions: 17, // (90-5)/5 = 17 steps
            label: "${durationMinutes.toInt()} min",
            onChanged: isEnabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
