import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final bool showReset;
  final Color primaryColor;

  const ControlButtons({
    super.key,
    required this.isRunning,
    required this.onPlayPause,
    required this.onReset,
    required this.showReset,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        if (showReset)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: FloatingActionButton(
              heroTag: 'reset_btn',
              elevation: 0,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              foregroundColor: theme.colorScheme.onSurface,
              onPressed: onReset,
              child: const Icon(Icons.stop),
            ),
          ),

        // Play/Pause Main Button
        SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            heroTag: 'play_pause_btn',
            elevation: 4,
            backgroundColor: primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
            onPressed: onPlayPause,
            child: Icon(isRunning ? Icons.pause : Icons.play_arrow, size: 36),
          ),
        ),
      ],
    );
  }
}
