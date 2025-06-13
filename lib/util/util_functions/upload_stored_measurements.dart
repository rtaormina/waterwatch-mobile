import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const _kMeasurementsKey = 'stored_measurements';

Future<List<Map<String, dynamic>>> retrieveStoredMeasurements() async {
  final prefs = await SharedPreferences.getInstance();
  final rawList = prefs.getStringList(_kMeasurementsKey) ?? <String>[];
  return rawList
      .map((jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>)
      .toList();
}

Future<void> uploadStoredMeasurements() async {
  final measurements = await retrieveStoredMeasurements();
  if (measurements.isEmpty) {
    return;
  }

  for (var measurement in measurements) {
    await uploadMeasurement(measurement);
  }
}
