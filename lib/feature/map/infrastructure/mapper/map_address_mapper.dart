import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../domain/map_address.dart';

class MapAddressMapper {
  const MapAddressMapper();

  MapAddress fromAddress(Address address) {
    return MapAddress(
      name: address.name,
      country: address.country,
      city: address.city,
      street: address.street,
      postcode: address.postcode,
      state: address.state,
    );
  }
}
