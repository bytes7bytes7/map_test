import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'app.dart';
import 'feature/common/application/bloc/bloc_watcher.dart';
import 'feature/map/infrastructure/dependency_injection.dart';

void main() {
  _initLogger();

  inject();

  runApp(const App());
}

void _initLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print(
        '[${record.time}] '
        '${record.level.name} | '
        '${record.loggerName}: '
        '${record.message}',
      );
    });

    Bloc.observer = BlocWatcher();
  }
}
