import '../../domain/map_point.dart';

abstract class MapRepository {
  Future<List<MapPoint>> getAddressSuggestions({
    required String query,
  });
}
