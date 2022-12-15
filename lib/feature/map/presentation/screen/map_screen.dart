import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get_it/get_it.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';

import '../../../common/presentation/hook/draggable_scrollable_controller.dart';
import '../../application/bloc/map/map_bloc.dart';
import '../../application/bloc/map_search/map_search_bloc.dart';
import '../../application/bloc/place_info/place_info_bloc.dart';
import '../../application/persistence/map_search_repository.dart';
import '../../domain/map_point.dart';
import '../widget/widget.dart';

const _zoomLevel = 15.0;
const _snackBarDuration = Duration(seconds: 3);
const _minBottomSheetSize = 0.0;
const _midBottomSheetSize = 0.2;
const _maxBottomSheetSize = 0.7;
const _bottomSheetDuration = Duration(milliseconds: 300);
const _bottomSheetBorderRadius = 10.0;
const _bottomSheetPadding = 12.0;
final _getIt = GetIt.instance;

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = useMapController();
    final isSearching = useValueNotifier(false);
    final searchFocus = useFocusNode();
    final searchController = useTextEditingController();
    final bottomSheetController = useDraggableScrollableController();

    useMapIsReady(
      controller: mapController,
      mapIsReady: () async {
        await mapController.currentLocation();
        await mapController.setZoom(zoomLevel: _zoomLevel);
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapBloc(
              const MapState(),
            ),
          ),
          BlocProvider(
            create: (context) => MapSearchBloc(
              const MapSearchState(),
              mapSearchRepository: _getIt.get<MapSearchRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PlaceInfoBloc(
              const PlaceInfoState(),
              mapSearchRepository: _getIt.get<MapSearchRepository>(),
            ),
          ),
        ],
        child: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            final point = state.selectedLocation?.point;
            if (point != null) {
              _selectNewPoint(mapController, point);
            }

            if (state.errorMessage.isNotEmpty) {
              _showError(context, error: state.errorMessage);
            }
          },
          builder: (context, state) {
            final mapBloc = context.read<MapBloc>();
            final mapSearchBloc = context.read<MapSearchBloc>();
            final placeInfoBloc = context.read<PlaceInfoBloc>();

            return _Body(
              mapController: mapController,
              searchController: searchController,
              isSearching: isSearching,
              searchFocus: searchFocus,
              mapBloc: mapBloc,
              mapSearchBloc: mapSearchBloc,
              placeInfoBloc: placeInfoBloc,
              bottomSheetController: bottomSheetController,
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectNewPoint(
    MapController mapController,
    MapPoint point,
  ) async {
    final points = await mapController.geopoints;

    for (final p in points) {
      await mapController.removeMarker(p);
    }

    await mapController.changeLocation(
      GeoPoint(
        latitude: point.latitude,
        longitude: point.longitude,
      ),
    );

    await mapController.setZoom(zoomLevel: _zoomLevel);
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
}

class _Body extends HookWidget {
  const _Body({
    required this.mapController,
    required this.searchController,
    required this.isSearching,
    required this.searchFocus,
    required this.mapBloc,
    required this.mapSearchBloc,
    required this.placeInfoBloc,
    required this.bottomSheetController,
  });

  final MapController mapController;
  final TextEditingController searchController;
  final ValueNotifier<bool> isSearching;
  final FocusNode searchFocus;
  final MapBloc mapBloc;
  final MapSearchBloc mapSearchBloc;
  final PlaceInfoBloc placeInfoBloc;
  final DraggableScrollableController bottomSheetController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    useEffect(() {
      mapController.listenerMapSingleTapping.addListener(_unfocusSearch);

      return () {
        mapController.listenerMapSingleTapping.removeListener(_unfocusSearch);
      };
    });

    useEffect(() {
      mapController.listenerMapLongTapping.addListener(_guessLocation);

      return () {
        mapController.listenerMapLongTapping.removeListener(_guessLocation);
      };
    });

    return Stack(
      children: [
        OSMFlutter(
          controller: mapController,
        ),
        SafeArea(
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
                      errorMessage: state.errorMessage,
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
        BlocConsumer<PlaceInfoBloc, PlaceInfoState>(
          listener: (context, state) {
            if (state.guessedLocation != null) {
              _showBottomSheet();
            } else {
              _hideBottomSheet();
            }
          },
          builder: (context, state) {
            return DraggableScrollableSheet(
              controller: bottomSheetController,
              initialChildSize: _minBottomSheetSize,
              minChildSize: _minBottomSheetSize,
              maxChildSize: _maxBottomSheetSize,
              snap: true,
              snapSizes: const [
                _minBottomSheetSize,
                _midBottomSheetSize,
                _maxBottomSheetSize,
              ],
              builder: (context, scrollController) {
                final location = state.guessedLocation;

                final title = location?.beautifiedName;
                final subtitle =
                    title != null ? location?.address?.description : null;

                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    height: size.height * _maxBottomSheetSize,
                    padding: const EdgeInsets.all(_bottomSheetPadding),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          _bottomSheetBorderRadius,
                        ),
                        topRight: Radius.circular(
                          _bottomSheetBorderRadius,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (title != null)
                              Text(
                                title,
                                style: theme.textTheme.headline6,
                              ),
                            const Spacer(),
                            RoundedIconButton(
                              icon: Icons.close,
                              foregroundColor: theme.colorScheme.onBackground,
                              backgroundColor: theme.colorScheme.background,
                              onPressed: _hideBottomSheet,
                            ),
                          ],
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyText2,
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _unfocusSearch() {
    isSearching.value = false;
    searchFocus.unfocus();
  }

  void _guessLocation() {
    final point = mapController.listenerMapLongTapping.value;

    if (point != null) {
      placeInfoBloc.add(
        GuessLocationEvent(
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      );
    }
  }

  void _showBottomSheet() {
    bottomSheetController.animateTo(
      _midBottomSheetSize,
      duration: _bottomSheetDuration,
      curve: Curves.easeInOut,
    );
  }

  void _hideBottomSheet() {
    bottomSheetController.animateTo(
      _minBottomSheetSize,
      duration: _bottomSheetDuration,
      curve: Curves.easeInOut,
    );
  }
}
