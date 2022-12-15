import '../../application/persistence/map_history_repository.dart';
import '../../domain/map_location.dart';

const _delay = Duration(seconds: 1);

class MapHistoryRAMRepository implements MapHistoryRepository {
  final _locations = <MapLocation>[];

  @override
  Future<List<MapLocation>> getHistory() {
    return Future.delayed(_delay, () => List.from(_locations));
  }

  @override
  Future<void> saveLocation(MapLocation location) async {
    _locations.add(location.clone());
  }
}
