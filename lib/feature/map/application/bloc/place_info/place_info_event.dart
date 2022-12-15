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
