import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// Returns the current [Position], after ensuring the user has granted
/// location permission. Throws a [PermissionDeniedException] if permission
/// is denied or a [LocationServiceDisabledException] if GPS/location services
/// are off.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1. Check if location services are enabled on the device.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw LocationServiceDisabledException();
  }

  // 2. Check whether permission is already granted.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Request permission for the first time.
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw PermissionDeniedException('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    throw PermissionDeniedException(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // 3. At this point, permission is granted, so we can fetch the location:
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

class LocationServiceDisabledException implements Exception {}

class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException(this.message);
  @override
  String toString() => 'PermissionDeniedException: $message';
}

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  /// The device’s current location (obtained in initState).
  LatLng? _currentLocation;

  /// Any error message while fetching location.
  String? _locationError;

  // Center of the map when first shown (fallback).
  final LatLng _initialCenter = LatLng(51.5, -0.09);

  // Current zoom level
  double _currentZoom = 13;

  // The selected point (if any)
  LatLng? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _fetchDeviceLocation();
  }

  Future<void> _fetchDeviceLocation() async {
    try {
      final pos = await determinePosition();
      final deviceLatLng = LatLng(pos.latitude, pos.longitude);

      setState(() {
        // 1) store the device location
        _currentLocation = deviceLatLng;
        // 2) initialize the “selectedPoint” to that same location
        _selectedPoint = deviceLatLng;
      });
    } on LocationServiceDisabledException {
      setState(() {
        _locationError = 'Location services are disabled.';
      });
    } on PermissionDeniedException catch (e) {
      setState(() {
        _locationError = e.message;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Error obtaining location: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      title: "Map",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1) Fixed-height container so the card never “jumps” size.
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                // 2) The actual map only gets inserted once _currentLocation is non-null
                //    and there was no error. Until then, we leave this layer “off.”
                if (_currentLocation != null && _locationError == null)
                  FlutterMap(
                    options: MapOptions(
                      minZoom: 2,
                      maxZoom: 18,
                      initialCenter: _currentLocation ?? _initialCenter,
                      initialZoom: _currentZoom,
                      // Only allow drag & pinchZoom; rotation is off by default.
                      interactionOptions: const InteractionOptions(
                          flags:
                              InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                      onTap: (tapPos, tappedLatLng) {
                        setState(() {
                          _selectedPoint = tappedLatLng;
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
                      if (_selectedPoint != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: _selectedPoint!,
                              child: const Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                // 3) While loading (no location & no error), show a spinner:
                Visibility(
                  visible: _currentLocation == null && _locationError == null,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

                // 4) If there was an error, show it (in red) on top of the blank map‐placeholder:
                Visibility(
                  visible: _locationError != null,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Center(
                    child: Text(
                      _locationError ?? 'Unknown error',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5) Display the selected coordinates (or a placeholder message)
          if (_selectedPoint != null)
            Text(
              'Selected: '
              'Lat ${_selectedPoint!.latitude.toStringAsFixed(5)}, '
              'Lng ${_selectedPoint!.longitude.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )
          else
            const Text(
              'Tap on the map to pick a point',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
