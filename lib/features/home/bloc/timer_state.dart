import 'package:equatable/equatable.dart';
import '../models/move_activity.dart';

enum TimerStatus { initial, running, paused, breakTime }

final class TimerState extends Equatable {
  const TimerState({
    this.duration = 60,
    this.status = TimerStatus.initial,
    this.focusDurationMinutes = 50,
    this.activities = const [],
  });

  final int duration;
  final TimerStatus status;
  final double focusDurationMinutes;
  final List<MoveActivity> activities;

  TimerState copyWith({
    int? duration,
    TimerStatus? status,
    double? focusDurationMinutes,
    List<MoveActivity>? activities,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
      focusDurationMinutes: focusDurationMinutes ?? this.focusDurationMinutes,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [
    duration,
    status,
    focusDurationMinutes,
    activities,
  ];
}
