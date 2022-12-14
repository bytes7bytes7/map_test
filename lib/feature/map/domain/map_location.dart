import 'package:equatable/equatable.dart';

import 'map_address.dart';
import 'map_point.dart';

class MapLocation extends Equatable {
  final MapPoint? point;
  final MapAddress? address;

  const MapLocation({
    this.point,
    this.address,
  });

  @override
  List<Object?> get props => [
        point,
        address,
      ];
}
