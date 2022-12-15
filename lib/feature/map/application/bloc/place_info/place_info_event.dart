part of 'place_info_bloc.dart';

abstract class PlaceInfoEvent extends Equatable {
  const PlaceInfoEvent();

  @override
  List<Object?> get props => [];
}

class GuessLocationEvent extends PlaceInfoEvent {
  const GuessLocationEvent({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
      ];
}

class SelectLocationEvent extends PlaceInfoEvent {
  const SelectLocationEvent({required this.location});

  final MapLocation location;

  @override
  List<Object?> get props => [location];
}

class ShowInfoEvent extends PlaceInfoEvent {
  const ShowInfoEvent();
}

class HideInfoEvent extends PlaceInfoEvent {
  const HideInfoEvent();
}
