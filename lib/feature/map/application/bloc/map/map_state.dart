part of 'map_bloc.dart';

class MapState extends Equatable with Loadable, Errorable {
  const MapState({
    this.isLoading = false,
    this.errorMessage = '',
    this.selectedMapLocation,
  });

  @override
  final bool isLoading;

  @override
  final String errorMessage;

  final MapLocation? selectedMapLocation;

  MapState copyWith({
    bool? isLoading,
    String? errorMessage = '',
    Wrapped<MapLocation>? selectedMapLocation,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedMapLocation: selectedMapLocation != null
          ? selectedMapLocation.value
          : this.selectedMapLocation,
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
        selectedMapLocation,
      ];
}
