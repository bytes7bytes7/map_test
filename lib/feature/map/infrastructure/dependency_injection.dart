import 'package:get_it/get_it.dart';

import '../application/persistence/map_search_repository.dart';
import 'persistence/map_search_test_repository.dart';

void inject() {
  GetIt.instance
      .registerSingleton<MapSearchRepository>(MapSearchTestRepository());
}
