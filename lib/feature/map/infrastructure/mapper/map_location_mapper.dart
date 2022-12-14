import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../domain/map_location.dart';
import 'map_address_mapper.dart';
import 'map_point_mapper.dart';

class MapLocationMapper {
  const MapLocationMapper({
    required MapPointMapper mapPointMapper,
    required MapAddressMapper mapAddressMapper,
  })  : _mapPointMapper = mapPointMapper,
        _mapAddressMapper = mapAddressMapper;

  final MapPointMapper _mapPointMapper;
  final MapAddressMapper _mapAddressMapper;

  MapLocation fromSearchInfo(SearchInfo searchInfo) {
    final point = searchInfo.point;
    final address = searchInfo.address;

    return MapLocation(
      point: point != null ? _mapPointMapper.fromGeoPoint(point) : null,
      address: address != null ? _mapAddressMapper.fromAddress(address) : null,
    );
  }
}
