import 'package:dio/dio.dart';
import 'package:foodie_driver_app/features/home/data/datasources/map_remote_data_source.dart';
import 'package:foodie_driver_app/features/home/data/repositories/map_repo_empl.dart';
import 'package:get_it/get_it.dart';

import '../service/api/api_service.dart';

final getIt = GetIt.instance;

void setupServiceLocatorApiService() {
  getIt.registerSingleton<ApiService>(
    ApiService(
      Dio(),
    ),
  );
}

void setupServiceLocatorMap() {
  getIt.registerSingleton<MapRepoEmpl>(MapRepoEmpl(MapRemoteDataSourceImpl(
    apiService: getIt.get<ApiService>(),
  )));
}
