import 'package:flutter/material.dart';

import 'app.dart';
import 'feature/map/infrastructure/dependency_injection.dart';

void main() {
  inject();

  runApp(const App());
}
