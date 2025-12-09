import 'package:get_it/get_it.dart';
import '../../features/home/bloc/timer_bloc.dart';
import '../utils/ticker.dart';
import '../services/audio_service.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services
  sl.registerLazySingleton(() => AudioService());

  // BLoC
  sl.registerFactory(() => TimerBloc(ticker: sl()));

  // External
  sl.registerLazySingleton(() => const Ticker());
}
