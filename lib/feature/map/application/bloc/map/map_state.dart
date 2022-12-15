part of 'map_bloc.dart';

class MapState extends Equatable with Loadable, Errorable {
  const MapState({
    this.isLoading = false,
    this.errorMessage = '',
  });

  @override
  final bool isLoading;

  @override
  final String errorMessage;

  MapState copyWith({
    bool? isLoading,
    String? errorMessage = '',
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
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
      ];
}
