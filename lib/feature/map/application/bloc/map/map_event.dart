part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class SelectLocationEvent extends MapEvent {
  const SelectLocationEvent({required this.location});

  final MapLocation location;

  @override
  List<Object?> get props => [location];
}
