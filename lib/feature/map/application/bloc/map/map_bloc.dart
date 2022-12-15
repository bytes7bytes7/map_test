import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/application/bloc/errorable.dart';
import '../../../../common/application/bloc/loadable.dart';
import '../../../../common/wrapped.dart';
import '../../../domain/map_location.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc(
    super.initialState,
  ) {
    on<SelectLocationEvent>(
      _selectLocation,
      transformer: restartable(),
    );
  }

  Future<void> _selectLocation(
    SelectLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(state.loading());

    emit(
      state.copyWith(
        selectedLocation: Wrapped(event.location),
      ),
    );
  }
}
