import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../application/persistence/map_search_repository.dart';
import 'persistence/map_search_dev_repository.dart';

void inject() {
  GetIt.instance
    ..registerSingleton<Dio>(Dio())
    ..registerSingleton<MapSearchRepository>(
      MapSearchDevRepository(
        dio: GetIt.instance.get<Dio>(),
      ),
    );
}
