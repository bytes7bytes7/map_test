import 'package:flutter/material.dart';

import 'feature/map/presentation/screen/map_screen.dart';
import 'theme/light_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Test',
      theme: lightTheme,
      home: MapScreen(),
    );
  }
}
