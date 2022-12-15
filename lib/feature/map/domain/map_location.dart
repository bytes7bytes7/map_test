import 'package:equatable/equatable.dart';

import 'map_address.dart';
import 'map_point.dart';

class MapLocation extends Equatable {
  const MapLocation({
    this.point,
    this.address,
  });

  final MapPoint? point;
  final MapAddress? address;

  String? get beautifiedName {
    final addressName = address?.beautifiedName;

    if (addressName != null) {
      return addressName;
    }

    final pointName = point?.beautifiedName;

    if (pointName != null) {
      return pointName;
    }

    return null;
  }

  @override
  List<Object?> get props => [
        point,
        address,
      ];
}
