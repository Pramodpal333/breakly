import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/utils/ticker.dart';
import '../data/activity_data.dart';
import '../models/move_activity.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final PreferencesService _preferencesService;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({
    required Ticker ticker,
    required PreferencesService preferencesService,
  }) : _ticker = ticker,
       _preferencesService = preferencesService,
       super(
         TimerState(
           duration: 50 * 60,
           status: TimerStatus.initial,
           activities:
               const [], // Initial state has no activities, will be populated on break
         ),
       ) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<FocusDurationChanged>(_onFocusDurationChanged);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(state.copyWith(status: TimerStatus.running));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state.status == TimerStatus.running ||
        state.status == TimerStatus.breakTime) {
      _tickerSubscription?.pause();
      emit(state.copyWith(status: TimerStatus.paused));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state.status == TimerStatus.paused) {
      _tickerSubscription?.resume();
      emit(state.copyWith(status: TimerStatus.running));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(
      TimerState(
        duration: (state.focusDurationMinutes * 60).toInt(),
        status: TimerStatus.initial,
        focusDurationMinutes: state.focusDurationMinutes,
        activities: defaultActivities,
      ),
    );
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(state.copyWith(duration: event.duration));
    } else {
      _tickerSubscription?.cancel();
      _handleTimerComplete(emit);
    }
  }

  void _onFocusDurationChanged(
    FocusDurationChanged event,
    Emitter<TimerState> emit,
  ) {
    if (state.status == TimerStatus.initial) {
      emit(
        state.copyWith(
          focusDurationMinutes: event.durationMinutes,
          duration: (event.durationMinutes * 60).toInt(),
        ),
      );
    }
  }

  void _handleTimerComplete(Emitter<TimerState> emit) {
    HapticFeedback.heavyImpact();

    // Work just finished, enter break mode manually
    // We do NOT start a timer here anymore.

    // Filter activities based on preference
    final location = _preferencesService.getLocationPreference();
    List<MoveActivity> filteredActivities;

    if (location == 'office') {
      // Only show stealth activities
      filteredActivities = defaultActivities.where((a) => a.isStealth).toList();
    } else {
      // Show all activites (Home or Anywhere)
      // We could randomize or shuffle here if desired, but defaultActivities allows sequential or swiper randomness handles it
      filteredActivities = List.from(defaultActivities);
    }

    emit(
      state.copyWith(
        status: TimerStatus.breakTime,
        activities: filteredActivities,
      ),
    );
    // No ticker subscription for break
  }
}
