import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';

import '../widget/widget.dart';

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = useMapController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
          ),
          const SafeArea(
            child: Positioned(
              top: 0,
              child: SearchBar(),
            ),
          ),
        ],
      ),
    );
  }
}
