import 'package:flutter/material.dart';

class TimerCircle extends StatelessWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final Color activeColor;
  final String statusLabel;

  const TimerCircle({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.activeColor,
    required this.statusLabel,
  });

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double progress = totalSeconds == 0
        ? 0
        : 1.0 - (remainingSeconds / totalSeconds);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Circle
        SizedBox(
          width: 280,
          height: 280,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 40,
            color: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        // Active Progress
        SizedBox(
          width: 280,
          height: 280,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 40,
            strokeCap: StrokeCap.round,
            color: activeColor,
            backgroundColor: Colors.transparent,
          ),
        ),
        // Text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(remainingSeconds),
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 64,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusLabel,
              style: TextStyle(
                // Custom style for label
                letterSpacing: 2.0,
                color: activeColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
