import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/application/bloc/errorable.dart';
import '../../../../common/application/bloc/loadable.dart';
import '../../../../common/wrapped.dart';
import '../../../domain/map_location.dart';
import '../../../domain/map_point.dart';
import '../../persistence/map_search_repository.dart';

part 'place_info_event.dart';

part 'place_info_state.dart';

class PlaceInfoBloc extends Bloc<PlaceInfoEvent, PlaceInfoState> {
  PlaceInfoBloc(
    super.initialState, {
    required MapSearchRepository mapSearchRepository,
  }) : _mapSearchRepository = mapSearchRepository {
    on<GuessLocationEvent>(
      _guessLocation,
      transformer: restartable(),
    );
    on<SelectLocationEvent>(
      _selectLocation,
      transformer: restartable(),
    );
    on<ShowInfoEvent>(
      _showInfo,
      transformer: sequential(),
    );
    on<HideInfoEvent>(
      _hideInfo,
      transformer: sequential(),
    );
  }

  final MapSearchRepository _mapSearchRepository;

  Future<void> _guessLocation(
    GuessLocationEvent event,
    Emitter<PlaceInfoState> emit,
  ) async {
    emit(
      state.loading().copyWith(
            showInfo: true,
          ),
    );

    try {
      final suggestions = await _mapSearchRepository.getPointSuggestions(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      final first = suggestions.firstOrNull;

      if (first != null) {
        emit(
          state.copyWith(
            isLoading: false,
            selectedLocation: Wrapped(
              SelectedLocation(
                point: MapPoint(
                  latitude: event.latitude,
                  longitude: event.longitude,
                ),
                nearestLocation: first,
                type: SelectType.guessed,
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            selectedLocation: Wrapped(
              SelectedLocation(
                point: MapPoint(
                  latitude: event.latitude,
                  longitude: event.longitude,
                ),
                nearestLocation: null,
                type: SelectType.guessed,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.error(
          'Ошибка при геокодировании',
        ),
      );
    }
  }

  Future<void> _selectLocation(
    SelectLocationEvent event,
    Emitter<PlaceInfoState> emit,
  ) async {
    emit(
      state.loading().copyWith(
            showInfo: true,
          ),
    );

    emit(
      state.copyWith(
        isLoading: false,
        selectedLocation: Wrapped(
          SelectedLocation(
            point: event.location.point,
            nearestLocation: event.location,
            type: SelectType.selected,
          ),
        ),
      ),
    );
  }

  Future<void> _showInfo(
    ShowInfoEvent event,
    Emitter<PlaceInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        showInfo: true,
      ),
    );
  }

  Future<void> _hideInfo(
    HideInfoEvent event,
    Emitter<PlaceInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        showInfo: false,
      ),
    );
  }
}
