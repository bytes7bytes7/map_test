import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';

import '../../../common/presentation/hook/draggable_scrollable_controller.dart';
import '../../application/bloc/map_search/map_search_bloc.dart';
import '../../application/bloc/place_info/place_info_bloc.dart';
import '../../application/persistence/map_search_repository.dart';
import '../../domain/map_point.dart';
import '../widget/widget.dart';

const _zoomLevel = 15.0;
const _snackBarDuration = Duration(seconds: 3);
const _initBottomSheetSize = 0.0;
const _minBottomSheetSize = 0.0;
const _midBottomSheetSize = 0.2;
const _maxBottomSheetSize = 0.7;
const _bottomSheetDuration = Duration(milliseconds: 300);
const _bottomSheetBorderRadius = 10.0;
const _bottomSheetPadding = 12.0;
final _getIt = GetIt.instance;
final _logger = Logger('$MapScreen');

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = useMapController(
      initMapWithUserPosition: false,
    );
    final isSearching = useValueNotifier(false);
    final searchFocus = useFocusNode();
    final searchController = useTextEditingController();
    final bottomSheetController = useDraggableScrollableController();
    final bottomSheetSize = useValueNotifier(_initBottomSheetSize);

    // await mapController.currentLocation();
    // await mapController.setZoom(zoomLevel: _zoomLevel);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
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
        child: Builder(
          builder: (context) {
            final mapSearchBloc = context.read<MapSearchBloc>();
            final placeInfoBloc = context.read<PlaceInfoBloc>();

            return _Body(
              mapController: mapController,
              searchController: searchController,
              isSearching: isSearching,
              searchFocus: searchFocus,
              mapSearchBloc: mapSearchBloc,
              placeInfoBloc: placeInfoBloc,
              bottomSheetController: bottomSheetController,
              bottomSheetSize: bottomSheetSize,
            );
          },
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
    required this.mapSearchBloc,
    required this.placeInfoBloc,
    required this.bottomSheetController,
    required this.bottomSheetSize,
  });

  final MapController mapController;
  final TextEditingController searchController;
  final ValueNotifier<bool> isSearching;
  final FocusNode searchFocus;
  final MapSearchBloc mapSearchBloc;
  final PlaceInfoBloc placeInfoBloc;
  final DraggableScrollableController bottomSheetController;
  final ValueNotifier<double> bottomSheetSize;

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

    useEffect(() {
      bottomSheetController.addListener(_trackBottomSheetSize);

      return () {
        bottomSheetController.removeListener(_trackBottomSheetSize);
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
              if (state.errorMessage.isNotEmpty) {
                _showError(context, error: state.errorMessage);
              }

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
                              placeInfoBloc.add(
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
        BlocListener<PlaceInfoBloc, PlaceInfoState>(
          listenWhen: (prev, curr) {
            return prev.showInfo != curr.showInfo;
          },
          listener: (context, state) {
            if (state.showInfo) {
              _showBottomSheet();
            } else {
              _hideBottomSheet();
            }
          },
          child: BlocConsumer<PlaceInfoBloc, PlaceInfoState>(
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                _showError(context, error: state.errorMessage);
              }

              final selectedLocation =
                  state.selectedLocation?.mapLocation.point;
              if (selectedLocation != null) {
                _selectNewPoint(mapController, selectedLocation);
              }
            },
            builder: (context, state) {
              return DraggableScrollableSheet(
                controller: bottomSheetController,
                initialChildSize: bottomSheetSize.value,
                minChildSize: _minBottomSheetSize,
                maxChildSize: _maxBottomSheetSize,
                snap: true,
                snapSizes: const [
                  _minBottomSheetSize,
                  _midBottomSheetSize,
                  _maxBottomSheetSize,
                ],
                builder: (context, scrollController) {
                  final isGuessed =
                      state.selectedLocation?.type == SelectType.guessed;

                  final location = state.selectedLocation;

                  final title = location?.mapLocation.beautifiedName;
                  final subtitle = title != null
                      ? location?.mapLocation.address?.description
                      : null;

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
                      child: state.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : isGuessed
                              ? GuessedLocationCard(
                                  title: title ?? '???',
                                  subtitle: subtitle,
                                  onSubmitted: () {},
                                  onClosed: () {
                                    placeInfoBloc.add(
                                      const HideInfoEvent(),
                                    );
                                  },
                                )
                              : SelectedLocationCard(
                                  title: title ?? '???',
                                  subtitle: subtitle,
                                  onClosed: () {
                                    placeInfoBloc.add(
                                      const HideInfoEvent(),
                                    );
                                  },
                                ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _unfocusSearch() {
    _logger.info('unfocus search');

    isSearching.value = false;
    searchFocus.unfocus();
  }

  void _guessLocation() {
    _logger.info('guess location');

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

  void _trackBottomSheetSize() {
    bottomSheetSize.value = bottomSheetController.size;

    if (bottomSheetSize.value == 0) {
      placeInfoBloc.add(const HideInfoEvent());
    }
  }

  Future<void> _selectNewPoint(
    MapController mapController,
    MapPoint point,
  ) async {
    _logger.info('select new point');

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
    _logger.info('show error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: _snackBarDuration,
        content: Text(
          error,
        ),
      ),
    );
  }

  void _showBottomSheet() {
    _logger.info('show BottomSheet');

    const animateTo = _midBottomSheetSize;

    bottomSheetController.animateTo(
      animateTo,
      duration: _bottomSheetDuration,
      curve: Curves.easeInOut,
    );
  }

  void _hideBottomSheet() {
    _logger.info('hide BottomSheet');

    const animateTo = _minBottomSheetSize;

    bottomSheetController.animateTo(
      animateTo,
      duration: _bottomSheetDuration,
      curve: Curves.easeInOut,
    );
  }
}
