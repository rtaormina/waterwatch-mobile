import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/measurement_state.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';

Future<void> uploadMeasurement(
  String apiUrl,
  LatLng? location,
  String waterSource,
  TemperatureObject metricTemperatureObject,
) async {
  String url = "$apiUrl/api/measurements/";
  final uri = Uri.parse(url);

  String token = await getCSRFToken();

  // Optional: set headers
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Referer': 'https://waterwatch.tudelft.nl',
    'X-CSRFToken': token,
    'Cookie': 'csrftoken=$token',
  };

  final now = DateTime.now();
  final today = DateFormat('yyyy-MM-dd').format(now);
  final time = DateFormat('HH:mm:ss').format(now);

  // Encode your payload as JSON
  final body = jsonEncode({
    "timestamp": DateTime.now().toUtc().toIso8601String(),
    "local_date": today,
    "local_time": time,
    "location": {
      "type": "Point",
      "coordinates": [location!.longitude, location.latitude]
    },
    "water_source": waterSource,
    "temperature": {
      "value": metricTemperatureObject.temperature,
      "sensor": metricTemperatureObject.sensorType,
      "time_waited": formatDurationToMinSec(metricTemperatureObject.duration)
    }
  });

  // Send the POST
  final response = await http.post(uri, headers: headers, body: body);

  // Check status code
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw http.ClientException(
      'Failed POST (${response.statusCode}): ${response.body}',
      uri,
    );
  }
}
