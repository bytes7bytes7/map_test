part of 'place_info_bloc.dart';

enum SelectType {
  selected,
  guessed,
}

class SelectedLocation extends Equatable {
  final MapPoint? point;
  final MapLocation? nearestLocation;
  final SelectType type;

  const SelectedLocation({
    required this.point,
    required this.nearestLocation,
    required this.type,
  });

  @override
  List<Object?> get props => [
        point,
        nearestLocation,
        type,
      ];
}

class PlaceInfoState extends Equatable with Loadable, Errorable {
  const PlaceInfoState({
    this.isLoading = false,
    this.errorMessage = '',
    this.selectedLocation,
    this.showInfo = false,
  });

  @override
  final bool isLoading;

  @override
  final String errorMessage;

  final SelectedLocation? selectedLocation;

  final bool showInfo;

  PlaceInfoState copyWith({
    bool? isLoading,
    String? errorMessage = '',
    Wrapped<SelectedLocation>? selectedLocation,
    bool? showInfo,
  }) {
    return PlaceInfoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLocation: selectedLocation != null
          ? selectedLocation.value
          : this.selectedLocation,
      showInfo: showInfo ?? this.showInfo,
    );
  }

  PlaceInfoState loading() => copyWith(isLoading: true);

  PlaceInfoState error(String errorMessage) => copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        selectedLocation,
        showInfo,
      ];
}
