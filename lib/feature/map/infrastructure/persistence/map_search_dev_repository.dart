import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../application/persistence/map_search_repository.dart';
import '../../domain/map_location.dart';
import '../mapper/map_location_mapper.dart';

class MapSearchDevRepository implements MapSearchRepository {
  const MapSearchDevRepository({
    required MapLocationMapper mapLocationMapper,
  }) : _mapLocationMapper = mapLocationMapper;

  final MapLocationMapper _mapLocationMapper;

  @override
  Future<List<MapLocation>> getAddressSuggestions({
    required String query,
  }) async {
    final result = await addressSuggestion(query);

    return result.map(_mapLocationMapper.fromSearchInfo).toList();
  }
}
