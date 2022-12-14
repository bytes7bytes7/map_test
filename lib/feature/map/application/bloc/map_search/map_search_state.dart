part of 'map_search_bloc.dart';

class MapSearchState extends Equatable with Loadable, Errorable {
  const MapSearchState({
    this.isLoading = false,
    this.errorMessage = '',
    this.query = '',
    this.searchSuggestions = const [],
    this.selectedSuggestion,
    this.updatedSuggestion = false,
  });

  @override
  final bool isLoading;

  @override
  final String errorMessage;

  final String query;

  final List<MapLocation> searchSuggestions;

  final MapLocation? selectedSuggestion;

  final bool updatedSuggestion;

  MapSearchState copyWith({
    bool? isLoading,
    String? errorMessage = '',
    String? query,
    List<MapLocation>? searchSuggestions,
    Wrapped<MapLocation>? selectedSuggestion,
    bool? updatedSuggestion = false,
  }) {
    return MapSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      selectedSuggestion: selectedSuggestion != null
          ? selectedSuggestion.value
          : this.selectedSuggestion,
      updatedSuggestion: updatedSuggestion ?? this.updatedSuggestion,
    );
  }

  MapSearchState loading() => copyWith(isLoading: true);

  MapSearchState error(String errorMessage) => copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );

  String? get queryForSelectedLocation {
    final location = selectedSuggestion;

    if (location == null) {
      return null;
    }

    final address = location.address;

    if (address != null) {
      final parts = [
        address.name,
        address.street,
        address.city,
        address.state,
        address.country,
      ].where((e) => e != null);

      final result = parts.firstOrNull;
      if (result != null) {
        return result;
      }
    }

    final point = location.point;

    if (point != null) {
      return '${point.latitude}, ${point.longitude}';
    }

    return '';
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        query,
        searchSuggestions,
        selectedSuggestion,
        updatedSuggestion,
      ];
}
