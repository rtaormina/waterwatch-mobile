import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({
    super.key,
    required this.measurementState,
    required this.getLocation,
  });

  final MeasurementState measurementState;
  final Future<void> Function(MeasurementState) getLocation;

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {

  late final TileProvider _tileProvider;

  @override
  void initState() {
    super.initState();

    _tileProvider = FMTCTileProvider(
      stores: {'mapStore': BrowseStoreStrategy.readUpdateCreate},
    );
    widget.getLocation(widget.measurementState);
  }

  @override
  Widget build(BuildContext context) {
    final measurementState = widget.measurementState;
    measurementState.reloadLocation = () => setState(() {});

    return CardComponent(
      title: "Measurement",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                if(measurementState.testMode)
                  const Center(
                    child: Text(
                      'Test Mode: Location not available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                if (measurementState.currentLocation == null &&
                    measurementState.locationError == null)
                  const Center(child: CircularProgressIndicator()),
                if (measurementState.currentLocation != null ||
                    measurementState.locationError != null)
                  FlutterMap(
                    options: MapOptions(
                      minZoom: 2,
                      maxZoom: 18,
                      initialCenter: measurementState.currentLocation ??
                          measurementState.initialCenter,
                      initialZoom: measurementState.currentZoom,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                      onTap: (tapPos, tappedLatLng) {
                        setState(() {
                          measurementState.location = tappedLatLng;
                        });
                      },
                    ),
                    children: [
                      if (!measurementState.testMode)
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          tileProvider: _tileProvider,
                          userAgentPackageName: 'com.example.app',
                        ),
                      if (measurementState.location != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: measurementState.location!,
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: mainColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (measurementState.locationError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                measurementState.locationError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 12),
          if (measurementState.location != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Selected: '
                'Lat ${measurementState.location!.latitude.toStringAsFixed(5)}, '
                'Lng ${measurementState.location!.longitude.toStringAsFixed(5)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Tap on the map to pick a point',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
