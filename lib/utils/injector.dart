import 'package:get_it/get_it.dart';
import 'package:projeto_estagio/repositories/event_repository.dart';
import 'package:projeto_estagio/repositories/pet_repository.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/utils/db.dart';
import 'package:sqflite/sqflite.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final db = await Db().database;
  getIt.registerSingleton<Database>(db);
  getIt.registerLazySingleton<PetRepository>(
    () => PetRepository(getIt<Database>()),
  );
  
  getIt.registerLazySingleton<VaccineRepository>(
    () => VaccineRepository(getIt<Database>()),
  );
  
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepository(getIt<Database>()),
  );
}