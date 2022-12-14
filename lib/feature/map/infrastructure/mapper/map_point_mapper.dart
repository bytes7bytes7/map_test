import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../domain/map_point.dart';

class MapPointMapper {
  const MapPointMapper();

  MapPoint fromGeoPoint(GeoPoint geoPoint) {
    return MapPoint(
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }
}
