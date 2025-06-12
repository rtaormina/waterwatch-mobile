import 'dart:convert';

import 'package:http/http.dart' as client;
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MeasurementState {
  bool testMode = false;
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

  bool showLoading = false;

  //reload function for home page
  void Function() reloadHomePage = () {};
  void Function() reloadLocation = () {};

  //clear out all values
  void clear() {
    metricTemperatureObject.clear();
  }

  //validating all metrics
  bool validateMetrics() {
    return metricTemperatureObject.validate();
  }

  Future<Map<String, dynamic>> sendData() async {
    String apiUrl = "https://waterwatch.tudelft.nl";
    //check if online

    //online
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

Future<String> getCSRFToken() async {
  final uri = Uri.parse('https://waterwatch.tudelft.nl/api/session/');
  final response = await client.get(uri, headers: {
    'Accept': 'application/json',
    'Referer': 'https://waterwatch.tudelft.nl',
  });

  final setCookie = response.headers['set-cookie'];
  print(setCookie);
  if (setCookie == null) {
    throw Exception('Missing Set-Cookie header when fetching CSRF token');
  }

  final csrfPair = setCookie.split(';').firstWhere(
        (segment) => segment.trim().startsWith('csrftoken='),
        orElse: () => throw Exception('No csrftoken segment in: $setCookie'),
      );
  final token = csrfPair.split('=')[1];
  print(token);
  return token;
}
