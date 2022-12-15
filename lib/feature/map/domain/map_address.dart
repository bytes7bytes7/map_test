import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class MapAddress extends Equatable {
  const MapAddress({
    this.postcode,
    this.name,
    this.street,
    this.city,
    this.state,
    this.country,
  });

  final String? postcode;
  final String? name;
  final String? street;
  final String? city;
  final String? state;
  final String? country;

  String? get beautifiedName {
    final parts = [
      name,
      street,
      city,
      state,
      country,
    ].where((e) => e != null);

    final result = parts.firstOrNull;
    if (result != null) {
      return result;
    }

    return null;
  }

  String? get description {
    final parts = [
      name,
      street,
      city,
      state,
      country,
    ].where((e) => e != null).toList();

    if (parts.isNotEmpty) {
      parts.removeAt(0);

      return parts.join(', ');
    }

    return null;
  }

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
