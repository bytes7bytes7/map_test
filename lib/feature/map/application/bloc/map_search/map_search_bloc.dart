import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/application/bloc/errorable.dart';
import '../../../../common/application/bloc/loadable.dart';
import '../../../../common/wrapped.dart';
import '../../../domain/map_location.dart';
import '../../persistence/map_search_repository.dart';

part 'map_search_event.dart';

part 'map_search_state.dart';

const _queryDebounce = Duration(milliseconds: 400);

class MapSearchBloc extends Bloc<MapSearchEvent, MapSearchState> {
  MapSearchBloc(
    super.initialState, {
    required MapSearchRepository mapSearchRepository,
  }) : _mapSearchRepository = mapSearchRepository {
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
  }

  final MapSearchRepository _mapSearchRepository;

  Future<void> _setQuery(
    SetQueryEvent event,
    Emitter<MapSearchState> emit,
  ) async {
    emit(state.loading());

    if (event.query.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          searchSuggestions: [],
        ),
      );
    } else {
      try {
        final suggestions = await _mapSearchRepository.getAddressSuggestions(
          query: event.query,
        );

        emit(
          state.copyWith(
            isLoading: false,
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

    emit(
      state.copyWith(
        isLoading: false,
        selectedSuggestion: Wrapped(event.location),
        updatedSuggestion: true,
        searchSuggestions: [],
      ),
    );
  }
}
