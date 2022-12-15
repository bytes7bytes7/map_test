import '../../domain/map_location.dart';

abstract class MapHistoryRepository {
  Future<List<MapLocation>> getHistory();

  Future<void> saveLocation(MapLocation location);
}
