import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

const _indent = '\n\t\t\t';

class BlocWatcher extends BlocObserver {
  final _logger = Logger('BlocWatcher');

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.info(
      'onCreate'
      '$_indent BLOC: ${bloc.runtimeType}',
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.info(
      'onEvent'
      '$_indent BLOC: ${bloc.runtimeType}, '
      '$_indent EVENT: $event',
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.info(
      'onChange'
      '$_indent BLOC: ${bloc.runtimeType}, '
      '$_indent CURRENT STATE: ${change.currentState}, '
      '$_indent NEXT STATE: ${change.nextState}',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.info(
      'onTransition'
      '$_indent BLOC: ${bloc.runtimeType}, '
      '$_indent EVENT: ${transition.event}, '
      '$_indent CURRENT STATE: ${transition.currentState}, '
      '$_indent NEXT STATE: ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.severe(
      'onError'
      '$_indent BLOC: ${bloc.runtimeType}, '
      '$_indent ERROR: $error',
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.info(
      'onClose'
      '$_indent BLOC: ${bloc.runtimeType}',
    );
  }
}
