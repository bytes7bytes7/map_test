part of 'map_search_bloc.dart';

abstract class MapSearchEvent extends Equatable {
  const MapSearchEvent();

  @override
  List<Object?> get props => [];
}

class SetQueryEvent extends MapSearchEvent {
  const SetQueryEvent({
    required this.query,
  });

  final String query;

  @override
  List<Object?> get props => [query];
}

class SelectSuggestionEvent extends MapSearchEvent {
  const SelectSuggestionEvent({required this.location});

  final MapLocation location;

  @override
  List<Object?> get props => [location];
}

class LoadHistoryEvent extends MapSearchEvent {
  const LoadHistoryEvent();
}
