import 'dart:async';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';
import 'package:waterwatch/util/util_functions/format_date_time.dart';
import 'package:waterwatch/util/util_functions/upload_measurement.dart';

class MeasurementState {
  bool testMode = false;
  //create a new instance of MeasurementState
  static MeasurementState initializeState(Future<bool> Function() onlineState, void Function() startMonitoring, Future<void> Function(Map<String, dynamic>) storeMeasurement) {
    MeasurementState state = MeasurementState();
    state.onlineState = onlineState;
    try {
      startMonitoring();
    } catch (e) {
      state.showError("Failed to start monitoring: $e");
    }
    return state;
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

  void clear() {
    waterSource = null;
    metricTemperatureObject.clear();
  }

  Future<bool> Function() onlineState = () async {
    return false;
  };

  Future<void> Function(Map<String, dynamic>) storeMeasurement = (payload) async {};

  void Function(String) showError = (e) {};

  bool validateMetrics() {
    if (waterSource == null || waterSource!.isEmpty) {
      showError("Please select a water source.");
      return false;
    }
    if( location == null) {
      showError("Please select a valid location.");
      return false;
    }
    if (metricTemperatureObject.sensorType == null ||
        metricTemperatureObject.sensorType!.isEmpty) {
      showError("Please enter a valid sensor type.");
      return false;
    }
    return metricTemperatureObject.validate();
  }

  Future<void> sendData() async {

    Map<String, dynamic> payload = getPayload();
    

    if (await onlineState()) {
      try {
        await uploadMeasurement(payload);
      } catch (e) {
        showError("Failed to upload measurement: $e");
        await storeMeasurement(payload);
      }
    } else {
      await storeMeasurement(payload);
    }
  }

  Map<String, dynamic> getPayload() {

    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    Map<String, dynamic> payload = {
      "timestamp": DateTime.now().toUtc().toIso8601String(),
      "local_date": today,
      "local_time": time,
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
        'time_waited': formatDurationToMinSec(metricTemperatureObject.duration),
      },
    };
    return payload;
  }

  
}
