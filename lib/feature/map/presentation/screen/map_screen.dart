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
    final isSearching = useValueNotifier(false);
    final searchFocus = useFocusNode();

    mapController.listenerMapSingleTapping.addListener(() {
      isSearching.value = false;
      searchFocus.unfocus();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Focus(
                  child: SearchBar(
                    focusNode: searchFocus,
                    onChanged: (query) {},
                  ),
                  onFocusChange: (hasFocus) {
                    isSearching.value = hasFocus;
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isSearching,
                  builder: (context, value, child) {
                    if (!value) {
                      return const SizedBox.shrink();
                    }

                    return child ?? const SizedBox.shrink();
                  },
                  child: const SearchList(
                    maxHeight: 300,
                    items: [],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
