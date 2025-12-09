import 'package:get_it/get_it.dart';
import '../../features/home/bloc/timer_bloc.dart';
import '../utils/ticker.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Blocs
  sl.registerFactory(() => TimerBloc(ticker: sl()));

  // External
  sl.registerLazySingleton(() => const Ticker());
}
