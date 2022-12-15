part of 'map_bloc.dart';

class MapState extends Equatable with Loadable, Errorable {
  const MapState({
    this.isLoading = false,
    this.errorMessage = '',
    this.selectedLocation,
  });

  @override
  final bool isLoading;

  @override
  final String errorMessage;

  final MapLocation? selectedLocation;

  MapState copyWith({
    bool? isLoading,
    String? errorMessage = '',
    Wrapped<MapLocation>? selectedLocation,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLocation: selectedLocation != null
          ? selectedLocation.value
          : this.selectedLocation,
    );
  }

  MapState loading() => copyWith(isLoading: true);

  MapState error(String errorMessage) => copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        selectedLocation,
      ];
}
