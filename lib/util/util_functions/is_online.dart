import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterwatch/util/util_functions/download_map.dart';
import 'package:waterwatch/util/util_functions/upload_stored_measurements.dart';

Future<bool> getOnline() async {
  
  final List<ConnectivityResult> results =
      await Connectivity().checkConnectivity();
  bool isOnline = results.any((r) => r != ConnectivityResult.none);
  return isOnline;
}

Timer? _pollTimer;

void startMonitoring() {
  // check immediately, then every 5 seconds:
  _doUpdate();
  _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
    _doUpdate();
  });
}

Future<void> _doUpdate() async {

  try {
    final online = await getOnline();
    if (online) {
      await uploadStoredMeasurements();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(!prefs.containsKey('saved_map')) {
        await prefs.setBool('saved_map', true);
        await preloadRegion();
      }
    }
  } catch (e) {
    throw Exception(
      'Error checking online status or uploading stored measurements: $e',
    );
  }
}

void stopMonitoring() {
  _pollTimer?.cancel();
  _pollTimer = null;
}
