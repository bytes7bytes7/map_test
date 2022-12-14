import 'package:equatable/equatable.dart';

class MapPoint extends Equatable {
  final double longitude;
  final double latitude;

  const MapPoint({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        longitude,
        latitude,
      ];
}
