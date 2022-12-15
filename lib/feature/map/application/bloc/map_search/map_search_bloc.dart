import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/application/bloc/errorable.dart';
import '../../../../common/application/bloc/loadable.dart';
import '../../../../common/wrapped.dart';
import '../../../domain/map_location.dart';
import '../../persistence/map_history_repository.dart';
import '../../persistence/map_search_repository.dart';

part 'map_search_event.dart';

part 'map_search_state.dart';

const _queryDebounce = Duration(milliseconds: 400);

class MapSearchBloc extends Bloc<MapSearchEvent, MapSearchState> {
  MapSearchBloc(
    super.initialState, {
    required MapSearchRepository mapSearchRepository,
    required MapHistoryRepository mapHistoryRepository,
  })  : _mapSearchRepository = mapSearchRepository,
        _mapHistoryRepository = mapHistoryRepository {
    on<SetQueryEvent>(
      _setQuery,
      transformer: (events, mapper) => sequential<SetQueryEvent>().call(
        events.debounceTime(_queryDebounce),
        mapper,
      ),
    );
    on<SelectSuggestionEvent>(
      _selectSuggestion,
      transformer: restartable(),
    );
    on<LoadHistoryEvent>(
      _loadHistory,
      transformer: droppable(),
    );
    on<SelectPickedLocationEvent>(
      _selectPickedLocation,
      transformer: restartable(),
    );
  }

  final MapSearchRepository _mapSearchRepository;
  final MapHistoryRepository _mapHistoryRepository;

  Future<void> _setQuery(
    SetQueryEvent event,
    Emitter<MapSearchState> emit,
  ) async {
    emit(state.loading());

    if (event.query.isEmpty) {
      add(const LoadHistoryEvent());
    } else {
      try {
        final suggestions = await _mapSearchRepository.getAddressSuggestions(
          query: event.query,
        );

        emit(
          state.copyWith(
            isLoading: false,
            loadedFromHistory: false,
            searchSuggestions: suggestions,
          ),
        );
      } catch (e) {
        emit(
          state.error(
            'Ошибка при загрузке адресов',
          ),
        );
      }
    }
  }

  Future<void> _selectSuggestion(
    SelectSuggestionEvent event,
    Emitter<MapSearchState> emit,
  ) async {
    emit(state.loading());

    if (state.loadedFromHistory) {
      emit(
        state.copyWith(
          isLoading: false,
          selectedSuggestion: Wrapped(event.location),
          updatedSuggestion: true,
        ),
      );
    } else {
      try {
        await _mapHistoryRepository.saveLocation(event.location);

        emit(
          state.copyWith(
            isLoading: false,
            selectedSuggestion: Wrapped(event.location),
            updatedSuggestion: true,
          ),
        );
      } catch (e) {
        emit(
          state.error('Не удалось обновить историю').copyWith(
                selectedSuggestion: Wrapped(event.location),
                updatedSuggestion: true,
              ),
        );
      }
    }
  }

  Future<void> _loadHistory(
    LoadHistoryEvent event,
    Emitter<MapSearchState> emit,
  ) async {
    emit(state.loading());

    try {
      final history = await _mapHistoryRepository.getHistory();

      emit(
        state.copyWith(
          isLoading: false,
          loadedFromHistory: true,
          searchSuggestions: history,
        ),
      );
    } catch (e) {
      emit(
        state.error('Не удалось загрузить историю'),
      );
    }
  }

  Future<void> _selectPickedLocation(
    SelectPickedLocationEvent event,
    Emitter<MapSearchState> emit,
  ) async {
    try {
      await _mapHistoryRepository.saveLocation(event.location);

      emit(
        state.copyWith(
          isLoading: false,
          selectedSuggestion: Wrapped(event.location),
          updatedSuggestion: true,
        ),
      );
    } catch (e) {
      emit(
        state.error('Не удалось обновить историю').copyWith(
              selectedSuggestion: Wrapped(event.location),
              updatedSuggestion: true,
            ),
      );
    }
  }
}
