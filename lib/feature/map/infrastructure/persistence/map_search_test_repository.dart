import '../../application/persistence/map_search_repository.dart';
import '../../domain/map_address.dart';
import '../../domain/map_location.dart';
import '../../domain/map_point.dart';

const _delay = Duration(seconds: 1);

class MapSearchTestRepository implements MapSearchRepository {
  @override
  Future<List<MapLocation>> getAddressSuggestions({required String query}) {
    return Future.delayed(_delay, () {
      return const [
        MapLocation(
          address: MapAddress(
            name: 'some name',
          ),
          point: MapPoint(
            longitude: 35,
            latitude: 85,
          ),
        ),
        MapLocation(
          address: MapAddress(
            name: 'some name 2',
          ),
          point: MapPoint(
            longitude: 41,
            latitude: 34,
          ),
        ),
        MapLocation(
          address: MapAddress(
            name: 'some name 3',
          ),
          point: MapPoint(
            longitude: 51,
            latitude: 24,
          ),
        ),
      ];
    });
  }

  @override
  Future<List<MapLocation>> getPointSuggestions({
    required double latitude,
    required double longitude,
  }) async {
    return Future.delayed(_delay, () {
      return const [
        MapLocation(
          address: MapAddress(
            name: 'name 4',
          ),
          point: MapPoint(
            latitude: 31,
            longitude: 11,
          ),
        ),
      ];
    });
  }
}
