import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';

import '../../application/bloc/map/map_bloc.dart';
import '../../application/bloc/map_search/map_search_bloc.dart';
import '../../application/persistence/map_search_repository.dart';
import '../../domain/map_point.dart';
import '../widget/widget.dart';

const _zoomLevel = 15.0;
const _snackBarDuration = Duration(seconds: 3);
final _getIt = GetIt.instance;

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = useMapController();
    final isSearching = useValueNotifier(false);
    final searchFocus = useFocusNode();
    final searchController = useTextEditingController();

    useMapIsReady(
      controller: mapController,
      mapIsReady: () async {
        await mapController.currentLocation();
        await mapController.setZoom(zoomLevel: _zoomLevel);
      },
    );

    mapController.listenerMapSingleTapping.addListener(() {
      isSearching.value = false;
      searchFocus.unfocus();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => MapBloc(
          const MapState(),
        ),
        child: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            final point = state.selectedMapLocation?.point;
            if (point != null) {
              _selectNewPoint(mapController, point);
            }

            if (state.errorMessage.isNotEmpty) {
              _showError(context, error: state.errorMessage);
            }
          },
          builder: (context, state) {
            final mapBloc = context.read<MapBloc>();

            return Stack(
              children: [
                OSMFlutter(
                  controller: mapController,
                ),
                SafeArea(
                  child: BlocProvider(
                    create: (context) => MapSearchBloc(
                      const MapSearchState(),
                      mapSearchRepository: _getIt.get<MapSearchRepository>(),
                    ),
                    child: BlocConsumer<MapSearchBloc, MapSearchState>(
                      listener: (context, state) {
                        if (state.updatedSuggestion) {
                          final query = state.queryForSelectedLocation;

                          if (query != null && searchController.text != query) {
                            searchController.text = query;
                          }
                        }
                      },
                      builder: (context, state) {
                        final mapSearchBloc = context.read<MapSearchBloc>();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Focus(
                              onFocusChange: (hasFocus) {
                                isSearching.value = hasFocus;
                              },
                              child: SearchBar(
                                controller: searchController,
                                focusNode: searchFocus,
                                onChanged: (query) {
                                  mapSearchBloc.add(
                                    SetQueryEvent(
                                      query: query,
                                    ),
                                  );
                                },
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isSearching,
                              builder: (context, value, child) {
                                if (!value) {
                                  return const SizedBox.shrink();
                                }

                                if (state.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return child ?? const SizedBox.shrink();
                              },
                              child: SearchList(
                                maxHeight: 300,
                                items: state.searchSuggestions.map(
                                  (e) {
                                    return SearchSuggestionCard(
                                      title: e.address?.name ?? 'address',
                                      onPressed: () {
                                        searchFocus.unfocus();
                                        mapSearchBloc.add(
                                          SelectSuggestionEvent(
                                            location: e,
                                          ),
                                        );
                                        mapBloc.add(
                                          SelectLocationEvent(
                                            location: e,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _selectNewPoint(MapController mapController, MapPoint point) {
    mapController
      ..changeLocation(
        GeoPoint(
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      )
      ..setZoom(zoomLevel: _zoomLevel);
  }

  void _showError(
    BuildContext context, {
    required String error,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: _snackBarDuration,
        content: Text(
          error,
        ),
      ),
    );
  }

  void _showPointDescription(BuildContext context) {
    final theme = Theme.of(context);

    showBarModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Title',
              style: theme.textTheme.headline6,
            ),
            Text(
              'Description',
              style: theme.textTheme.bodyText1,
            ),
          ],
        );
      },
    );
  }
}
