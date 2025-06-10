import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waterwatch/theme.dart';

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
                if (_currentLocation == null && _locationError == null)
                  const Center(child: CircularProgressIndicator()),

                // Otherwise (either we have a location _or_ an error occurred),
                // display the map. If _currentLocation is null (error case),
                // it will default to _initialCenter.
                if (!(_currentLocation == null && _locationError == null))
                  FlutterMap(
                    options: MapOptions(
                      minZoom: 2,
                      maxZoom: 18,
                      initialCenter: _currentLocation ?? _initialCenter,
                      initialZoom: _currentZoom,
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
          if (_locationError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _locationError!,
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
          if (_selectedPoint != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Selected: '
                'Lat ${_selectedPoint!.latitude.toStringAsFixed(5)}, '
                'Lng ${_selectedPoint!.longitude.toStringAsFixed(5)}',
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
