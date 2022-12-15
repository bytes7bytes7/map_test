// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';

import '../../application/persistence/map_search_repository.dart';
import '../../domain/map_address.dart';
import '../../domain/map_location.dart';
import '../../domain/map_point.dart';

const _authority = 'photon.komoot.io';
const _addressSuggestionEndpoint = '/api';
const _pointSuggestionEndpoint = '/reverse';

MapLocation mapLocationFromApi(Map<String, dynamic> json) {
  return MapLocation(
    point: mapPointFromApi(json['geometry']),
    address: mapAddressFromApi(json['properties']),
  );
}

MapPoint mapPointFromApi(Map<String, dynamic> json) {
  return MapPoint(
    latitude: json['coordinates'][1],
    longitude: json['coordinates'][0],
  );
}

MapAddress mapAddressFromApi(Map<String, dynamic> json) {
  return MapAddress(
    postcode: json['postcode'],
    name: json['name'],
    street: json['street'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
  );
}

class MapSearchDevRepository implements MapSearchRepository {
  const MapSearchDevRepository({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<MapLocation>> getAddressSuggestions({
    required String query,
    int limit = 5,
  }) async {
    final response = await _dio.getUri(
      Uri.https(
        _authority,
        _addressSuggestionEndpoint,
        {
          'q': query,
          'limit': limit == 0 ? '' : '$limit',
        },
      ),
    );
    final json = response.data;

    return (json['features'] as List)
        .map<MapLocation>((e) => mapLocationFromApi(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MapLocation>> getPointSuggestions({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.getUri(
      Uri.https(
        _authority,
        _pointSuggestionEndpoint,
        {
          'lat': '$latitude',
          'lon': '$longitude',
        },
      ),
    );

    final json = response.data;

    return (json['features'] as List)
        .map<MapLocation>((e) => mapLocationFromApi(e as Map<String, dynamic>))
        .toList();
  }
}
