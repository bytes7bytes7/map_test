import 'package:equatable/equatable.dart';

class MapAddress extends Equatable {
  final String? postcode;
  final String? name;
  final String? street;
  final String? city;
  final String? state;
  final String? country;

  const MapAddress({
    this.postcode,
    this.name,
    this.street,
    this.city,
    this.state,
    this.country,
  });

  @override
  List<Object?> get props => [
        postcode,
        name,
        street,
        city,
        state,
        country,
      ];
}
