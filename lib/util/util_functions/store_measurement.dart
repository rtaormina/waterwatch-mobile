import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterwatch/util/measurement_state.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';

const _kMeasurementsKey = 'stored_measurements';

Future<void> storeMeasurement(
  String apiUrl, // retained in signature but not stored locally
  LatLng? location,
  String waterSource,
  TemperatureObject metricTemperatureObject,
) async {
  final prefs = await SharedPreferences.getInstance();

  // 1) Gather timestamps and format
  final now = DateTime.now();
  final today = DateFormat('yyyy-MM-dd').format(now);
  final time = DateFormat('HH:mm:ss').format(now);

  // 2) Build the payload map
  final measurement = {
    'timestamp': now.toUtc().toIso8601String(),
    'local_date': today,
    'local_time': time,
    'location': {
      'type': 'Point',
      'coordinates': [location!.longitude, location.latitude],
    },
    'water_source': waterSource,
    'temperature': {
      'value': metricTemperatureObject.temperature,
      'sensor': metricTemperatureObject.sensorType,
      'time_waited': formatDurationToMinSec(metricTemperatureObject.duration),
    },
  };

  // 3) Load existing list (or start fresh), append, and save
  final rawList = prefs.getStringList(_kMeasurementsKey) ?? <String>[];
  rawList.add(jsonEncode(measurement));
  await prefs.setStringList(_kMeasurementsKey, rawList);
}


