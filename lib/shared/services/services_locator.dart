import 'package:daily_schedules/shared/local/sqldb.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    /// Database Sqlite
    sl.registerLazySingleton(() => SqlDb());

    /// UUID
    sl.registerLazySingleton(() => const Uuid());
  }
}
