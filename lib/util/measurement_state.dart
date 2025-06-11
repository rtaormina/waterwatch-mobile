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
  LatLng location = const LatLng(0, 0);

  //selected metrics
  bool metricTemperature = true;
  TemperatureObject metricTemperatureObject = TemperatureObject();

  //reload function for home page
  void Function() reloadHomePage = () {};

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
      'X-CSRFToken': await getCSRF(),

      // add other headers like Authorization if needed
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
        "coordinates": [location.longitude, location.latitude]
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
      // Decode and return JSON
      print(jsonDecode(response.body));
      print("brrr");
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Handle error https://stackoverflow.com/questions/22812721/why-do-i-get-csrf-cookie-not-set-when-post-to-django-rest-framework
      //AssertionError: The `request` argument must be an instance of `django.http.HttpRequest`, not `rest_framework.request.Request`.
      //backend     | [10/Jun/2025 16:59:14] "POST /api/measurements/ HTTP/1.0" 500 120500
      throw http.ClientException(
        'Failed POST (${response.statusCode}): ${response.body}',
        uri,
      );
    }

    //offline
  }

  Future<String> getCSRF() async {
    // Initial GET request to get the CSRF token
    var response = await http
        .get(Uri.parse('https://waterwatch.tudelft.nl/api/measurements'));

    // Extract the CSRF token (example from a cookie)
    String? csrfToken;
    var setCookie = response.headers['set-cookie'];
    print(response.headers);
    print(response.body);
    if (setCookie != null) {
      var cookies = setCookie.split(';');
      for (var cookie in cookies) {
        if (cookie.trim().startsWith('csrftoken=')) {
          csrfToken = cookie.trim().substring('csrftoken='.length);
          break;
        }
      }
    }

    if (csrfToken == null) {
      print('CSRF token not found.');
      return "";
    }

    print(csrfToken);
    return csrfToken;
  }
}

String formatDurationToMinSec(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
