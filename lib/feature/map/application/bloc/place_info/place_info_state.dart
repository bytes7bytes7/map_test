part of 'place_info_bloc.dart';

class PlaceInfoState extends Equatable with Loadable, Errorable {
  const PlaceInfoState({
    this.isLoading = false,
    this.errorMessage = '',
    this.guessedLocation,
    this.showInfo = false,
  });

  @override
  final bool isLoading;

  @override
  final String errorMessage;

  final MapLocation? guessedLocation;

  final bool showInfo;

  PlaceInfoState copyWith({
    bool? isLoading,
    String? errorMessage = '',
    Wrapped<MapLocation>? guessedLocation,
    bool? showInfo,
  }) {
    return PlaceInfoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      guessedLocation: guessedLocation != null
          ? guessedLocation.value
          : this.guessedLocation,
      showInfo: showInfo ?? this.showInfo,
    );
  }

  PlaceInfoState loading() => copyWith(isLoading: true);

  PlaceInfoState error(String error) => copyWith(
        isLoading: false,
        errorMessage: error,
      );

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        guessedLocation,
        showInfo,
      ];
}
