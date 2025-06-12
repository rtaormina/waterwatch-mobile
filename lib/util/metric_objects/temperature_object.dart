
import 'package:flutter/material.dart';
import 'package:waterwatch/util/metric_objects/metric_object.dart';

class TemperatureObject extends MetricObject {
  String sensorType = "Digital Thermometer";
  double temperature = -1;
  Duration duration = Duration.zero;
  bool tempUnitCelsius = true;

  bool sensorTypeError = false;
  bool temperatureError = false;
  bool durationError = false;

  TextEditingController sensorController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();

  @override
  void clear() {
    sensorType = "Digital Thermometer";
    temperature = -1;
    duration = Duration.zero;
    tempUnitCelsius = true;

    sensorTypeError = false;
    temperatureError = false;
    durationError = false;

    sensorController.text = "";
    temperatureController.text = "";
  }

  @override
  bool validate() {
    bool sensorValid = sensorTypeValid();
    bool tempValid = temperatureValid();
    bool durationValidB = durationValid();
    return sensorValid && tempValid && durationValidB;
  }

  bool sensorTypeValid() {
    sensorTypeError = sensorType.isEmpty;
    return !sensorTypeError;
  }

  bool temperatureValid() {
    if (tempUnitCelsius) {
      temperatureError = temperature < 0 || temperature > 100;
    } else {
      temperatureError = temperature < 32 || temperature > 212;
    }
    return !temperatureError;
  }

  bool durationValid() {
    durationError = duration.inSeconds <= 0;
    return !durationError;
  }
}
