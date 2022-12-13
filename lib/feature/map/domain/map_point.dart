import 'package:equatable/equatable.dart';

import 'address.dart';
import 'geo_point.dart';

class MapPoint extends Equatable {
  final GeoPoint? point;
  final Address? address;

  const MapPoint({
    this.point,
    this.address,
  });

  @override
  List<Object?> get props => [
        point,
        address,
      ];
}
