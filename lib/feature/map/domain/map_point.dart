import 'package:equatable/equatable.dart';

class MapPoint extends Equatable {
  const MapPoint({
    required this.latitude,
    required this.longitude,
  });

  final double longitude;
  final double latitude;

  String get beautifiedName {
    return '$latitude, $longitude';
  }

  MapPoint clone() {
    return MapPoint(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  List<Object?> get props => [
        longitude,
        latitude,
      ];
}
