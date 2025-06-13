import 'package:http/http.dart' as client;
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';
import 'package:waterwatch/util/util_functions/is_online.dart';
import 'package:waterwatch/util/util_functions/store_measurement.dart';
import 'package:waterwatch/util/util_functions/upload_measurement.dart';

class MeasurementState {
  bool testMode = false;
  //create a new instance of MeasurementState
  static MeasurementState initializeState() {
    return MeasurementState();
  }

  //general measurement state
  String? waterSource;
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
    waterSource = null;
    metricTemperatureObject.clear();
    
  }

  void Function(String) showError = (e) {};

  //validating all metrics
  bool validateMetrics() {
    if(waterSource == null || waterSource!.isEmpty) {
      showError("Please select a water source.");
      return false;
    }
    if(metricTemperatureObject.sensorType == null || metricTemperatureObject.sensorType!.isEmpty) {
      showError("Please enter a valid sensor type.");
      return false;
    }
    return metricTemperatureObject.validate();
  }

  Future<void> sendData() async {

    Map<String, dynamic> payload = {
      'water_source': waterSource,
      'location': {
        'type': 'Point',
        'coordinates': [
          location!.longitude,
          location!.latitude,
        ],
      },
      'temperature': {
        'value': metricTemperatureObject.temperature,
        'sensor': metricTemperatureObject.sensorType,
        'time_waited':
            formatDurationToMinSec(metricTemperatureObject.duration),
      },
    };

    if (await getOnline()) {
      await uploadMeasurement(payload);
    } else {
      await storeMeasurement(payload);
    }
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

  if (setCookie == null) {
    throw Exception('Missing Set-Cookie header when fetching CSRF token');
  }

  final csrfPair = setCookie.split(';').firstWhere(
        (segment) => segment.trim().startsWith('csrftoken='),
        orElse: () => throw Exception('No csrftoken segment in: $setCookie'),
      );
  final token = csrfPair.split('=')[1];

  return token;
}
