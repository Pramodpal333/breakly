import 'package:equatable/equatable.dart';
import '../models/move_activity.dart';

enum TimerStatus { initial, running, paused, breakTime }

final class TimerState extends Equatable {
  const TimerState({
    this.duration = 60,
    this.status = TimerStatus.initial,
    this.focusDurationMinutes = 50,
    this.currentActivity,
  });

  final int duration;
  final TimerStatus status;
  final double focusDurationMinutes;
  final MoveActivity? currentActivity;

  TimerState copyWith({
    int? duration,
    TimerStatus? status,
    double? focusDurationMinutes,
    MoveActivity? currentActivity,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
      focusDurationMinutes: focusDurationMinutes ?? this.focusDurationMinutes,
      currentActivity: currentActivity ?? this.currentActivity,
    );
  }

  @override
  List<Object?> get props => [
    duration,
    status,
    focusDurationMinutes,
    currentActivity,
  ];
}
