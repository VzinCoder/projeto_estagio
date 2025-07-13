import 'package:get_it/get_it.dart';
import 'package:projeto_estagio/repositories/api_repository.dart';
import 'package:projeto_estagio/repositories/event_repository.dart';
import 'package:projeto_estagio/repositories/pet_repository.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/services/api_services.dart';
import 'package:projeto_estagio/utils/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';
import './jwt_interceptor.dart';
import 'package:uuid/uuid.dart';
import '../services/auth_services.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final db = await Db().database;
  final authService = AuthService();
  final dio = Dio();

  dio.interceptors.add(JwtInterceptor(dio));

  final uuid = Uuid();

  getIt.registerSingleton<AuthService>(authService);

  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<Database>(db);

  getIt.registerSingleton<Uuid>(uuid);

  getIt.registerLazySingleton<PetRepository>(
    () => PetRepository(getIt<Database>()),
  );
  
  getIt.registerLazySingleton<VaccineRepository>(
    () => VaccineRepository(getIt<Database>()),
  );
  
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepository(getIt<Database>()),
  );

  getIt.registerLazySingleton<ApiRepository>(
    ()=> ApiRepository(
      petRepository: getIt.get<PetRepository>(), 
      vaccineRepository: getIt.get<VaccineRepository>(), 
      eventRepository: getIt.get<EventRepository>(), 
      dioClient: DioClient()
    )
  );
}