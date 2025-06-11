import 'package:geolocator/geolocator.dart';

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
