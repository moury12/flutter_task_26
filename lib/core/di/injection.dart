import 'package:get_it/get_it.dart';
import 'package:task28_02/app_export.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Network
  getIt.registerLazySingleton<Dio>(() => DioClient.createDio());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<Dio>()),
  );
}
