import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key, required this.measurementState, required this.getLocation});

  final MeasurementState measurementState;
  final Future<void> Function(MeasurementState) getLocation;

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  @override
  void initState() {
    super.initState();
    widget.getLocation(widget.measurementState);
  }

  @override
  Widget build(BuildContext context) {
    MeasurementState measurementState = widget.measurementState;
    measurementState.reloadLocation = () {
      setState(() {});
    };
    return CardComponent(
      title: "Measurement",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1) Fixed-height container so the card never “jumps” size.
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                // If still loading (no location & no error), show a spinner.
                if (measurementState.currentLocation == null &&
                    measurementState.locationError == null)
                  const Center(child: CircularProgressIndicator()),

                // Otherwise (either we have a location _or_ an error occurred),
                // display the map. If _currentLocation is null (error case),
                // it will default to _initialCenter.
                if (!(measurementState.currentLocation == null &&
                    measurementState.locationError == null))
                  FlutterMap(
                    options: MapOptions(
                      minZoom: 2,
                      maxZoom: 18,
                      initialCenter: measurementState.currentLocation ??
                          measurementState.initialCenter,
                      initialZoom: measurementState.currentZoom,
                      interactionOptions: const InteractionOptions(
                          flags:
                              InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                      onTap: (tapPos, tappedLatLng) {
                        setState(() {
                          measurementState.location = tappedLatLng;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.yourapp',
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

          // 2) Show the error message (if any) underneath the map panel:
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

          // 3) Always allow the user to see/choose the “Selected” coordinates below:
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
