import '../../domain/map_location.dart';

abstract class MapSearchRepository {
  Future<List<MapLocation>> getAddressSuggestions({
    required String query,
  });
}
