import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MeasurementState {
  //create a new instance of MeasurementState
  static MeasurementState initializeState() {
    return MeasurementState();
  }

  //general measurement state
  String waterSource = 'network';
  LatLng? location;
  LatLng? currentLocation;
  String? locationError;
  double currentZoom = 13;
  final LatLng initialCenter = const LatLng(51.5, -0.09);

  //selected metrics
  bool metricTemperature = true;
  TemperatureObject metricTemperatureObject = TemperatureObject();

  //reload function for home page
  void Function() reloadHomePage = () {};
  void Function() reloadLocation = () {};

  //clear out all values
  void clear() {}

  //validating all metrics
  void validateMetrics() {
    metricTemperatureObject.validate();
  }

  Future<Map<String, dynamic>> sendData() async {
    String API_URL = "https://waterwatch.tudelft.nl";
    //check if online

    //online
    String url = "$API_URL/api/measurements/";
    final uri = Uri.parse(url);

    // Optional: set headers
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
        "coordinates": [location!.longitude, location!.latitude]
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw http.ClientException(
        'Failed POST (${response.statusCode}): ${response.body}',
        uri,
      );
    }

    //offline
  }
}

String formatDurationToMinSec(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
