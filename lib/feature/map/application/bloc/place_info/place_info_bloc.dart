import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/application/bloc/errorable.dart';
import '../../../../common/application/bloc/loadable.dart';
import '../../../../common/wrapped.dart';
import '../../../domain/map_location.dart';
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
  }

  final MapSearchRepository _mapSearchRepository;

  Future<void> _guessLocation(
    GuessLocationEvent event,
    Emitter<PlaceInfoState> emit,
  ) async {
    emit(state.loading());

    try {
      final suggestions = await _mapSearchRepository.getPointSuggestions(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      emit(
        state.copyWith(
          isLoading: false,
          guessedLocation: Wrapped(suggestions.firstOrNull),
        ),
      );
    } catch (e) {
      emit(
        state.error(
          'Ошибка при геокодировании',
        ),
      );
    }
  }
}
