import 'package:equatable/equatable.dart';

class GeoPoint extends Equatable {
  final double longitude;
  final double latitude;

  const GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        longitude,
        latitude,
      ];
}
