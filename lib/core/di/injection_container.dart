import 'package:get_it/get_it.dart';
import '../../features/home/bloc/timer_bloc.dart';
import '../utils/ticker.dart';
import '../services/audio_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../services/preferences_service.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => PreferencesService(sharedPreferences));

  // Services
  sl.registerLazySingleton(() => AudioService(sl()));

  // BLoC
  sl.registerFactory(() => TimerBloc(ticker: sl(), preferencesService: sl()));

  // External
  sl.registerLazySingleton(() => const Ticker());
}
