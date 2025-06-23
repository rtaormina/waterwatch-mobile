import 'dart:async';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';
import 'package:waterwatch/util/util_functions/format_date_time.dart';

class MeasurementState {

  //flag for disabling map in tests
  bool testMode = false;
  
  //create a new instance of MeasurementState
  static MeasurementState initializeState(
    Future<bool> Function() onlineState,
    void Function() startMonitoring,
    Future<void> Function(Map<String, dynamic>) storeMeasurement,
    Future<void> Function(Map<String, dynamic>) uploadMeasurement,
  ) {
    MeasurementState state = MeasurementState();
    state.onlineState = onlineState;
    state.storeMeasurement = storeMeasurement;
    state.uploadMeasurement = uploadMeasurement;
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

  //turns to true when app is uploading data
  bool showLoading = false;

  //reload function for home page
  void Function() reloadHomePage = () {};
  void Function() reloadLocation = () {};

  //clearing all the fields of the measurement
  void clear() {
    waterSource = null;
    metricTemperatureObject.clear();
  }

  //injected function for online state checking
  Future<bool> Function() onlineState = () async {
    return false;
  };

  //injected functions for storing and uploading measurements
  Future<void> Function(Map<String, dynamic>) storeMeasurement =
      (payload) async {};
  Future<void> Function(Map<String, dynamic>) uploadMeasurement =
      (payload) async {};

  //set in homescreen widget to show error messages
  void Function(String) showError = (e) {};

  //validating the metrics before sending
  bool validateMetrics() {
    if (waterSource == null || waterSource!.isEmpty) {
      showError("Please select a water source.");
      return false;
    }
    if (location == null) {
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

  //fires when the submit button is pressed
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

  //creates payload for the measurement that needs to be uploaded or stored
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
        'value': metricTemperatureObject.tempUnitCelsius
            ? double.parse(
                metricTemperatureObject.temperature.toStringAsFixed(1))
            : double.parse(
                ((metricTemperatureObject.temperature - 32) * (5 / 9))
                    .toStringAsFixed(1)),
        'sensor': metricTemperatureObject.sensorType,
        'time_waited': formatDurationToMinSec(metricTemperatureObject.duration),
      },
    };
    return payload;
  }
}
