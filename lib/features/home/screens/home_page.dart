import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/services/version_service.dart';
import '../../../core/services/audio_service.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import '../widgets/timer_circle.dart';
import '../widgets/exercise_swiper.dart';
import '../widgets/duration_slider.dart';
import '../widgets/control_buttons.dart';
import '../widgets/settings_bottom_sheet.dart';

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
    final theme = Theme.of(context);

    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (previous, current) =>
          previous.status != TimerStatus.breakTime &&
          current.status == TimerStatus.breakTime,
      listener: (context, state) {
        // Play ringtone when break starts
        sl<AudioService>().playRingtone();
      },
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final isBreak = state.status == TimerStatus.breakTime;
          final primaryColor = isBreak
              ? theme.colorScheme.secondary
              : theme.colorScheme.primary;

          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: _buildHeader(theme, context, state),
                  ),

                  if (isBreak)
                    Expanded(
                      child: ExerciseSwiper(
                        activities: state.activities,
                        onStartFocus: () {
                          // Stop ringtone when user starts focus
                          sl<AudioService>().stop();
                          context.read<TimerBloc>().add(const TimerReset());
                          context.read<TimerBloc>().add(
                            TimerStarted(
                              duration: (state.focusDurationMinutes * 60)
                                  .toInt(),
                            ),
                          );
                        },
                      ),
                    )
                  else ...[
                    // const Spacer(),
                    Gap(50),
                    // Main Timer Display
                    TimerCircle(
                      totalSeconds: (state.focusDurationMinutes * 60).toInt(),
                      remainingSeconds: state.duration,
                      activeColor: primaryColor,
                      statusLabel: "WORKING",
                    ),

                    const Spacer(),

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
                ],
              ),
            ),
          );
        },
      ),
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
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const SettingsBottomSheet(),
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
