import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import '../widgets/timer_circle.dart';
import '../widgets/activity_card.dart';
import '../widgets/duration_slider.dart';
import '../widgets/control_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TimerBloc>(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isBreak = state.status == TimerStatus.breakTime;
        final primaryColor = isBreak
            ? theme.colorScheme.secondary
            : theme.colorScheme.primary;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  // Header
                  _buildHeader(theme, context, state),
                  const Spacer(),

                  // Main Timer Display
                  TimerCircle(
                    totalSeconds: isBreak
                        ? 300
                        : (state.focusDurationMinutes * 60)
                              .toInt(), // Approximation for total logic
                    remainingSeconds: state.duration,
                    activeColor: primaryColor,
                    statusLabel: isBreak ? "RESTING" : "WORKING",
                  ),

                  const Spacer(),

                  // Activity Card (Only shows during break)
                  if (state.currentActivity != null)
                    ActivityCard(activity: state.currentActivity!),

                  if (!isBreak)
                    DurationSlider(
                      durationMinutes: state.focusDurationMinutes,
                      onChanged: state.status == TimerStatus.initial
                          ? (val) => context.read<TimerBloc>().add(
                              FocusDurationChanged(durationMinutes: val),
                            )
                          : null,
                    ),

                  const SizedBox(height: 30),

                  // Controls
                  ControlButtons(
                    isRunning: state.status == TimerStatus.running,
                    onPlayPause: () {
                      if (state.status == TimerStatus.running) {
                        context.read<TimerBloc>().add(const TimerPaused());
                      } else {
                        context.read<TimerBloc>().add(
                          TimerStarted(duration: state.duration),
                        );
                      }
                    },
                    onReset: () =>
                        context.read<TimerBloc>().add(const TimerReset()),
                    showReset: state.status != TimerStatus.initial,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context, TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Breakly",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              state.status == TimerStatus.breakTime
                  ? "Recharge Mode"
                  : "Focus Mode",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Settings coming in v2!")),
            );
          },
          icon: Icon(
            Icons.settings_outlined,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
