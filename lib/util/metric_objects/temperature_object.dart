import 'package:waterwatch/util/metric_objects/metric_object.dart';

class TemperatureObject extends MetricObject {
  String sensorType = "";
  double temperature = -1;
  Duration duration = Duration.zero;
  bool tempUnitCelsius = true;

  bool sensorTypeError = false;
  bool temperatureError = false;
  bool durationError = false;

  @override
  void validate() {
    sensorTypeValid();
    temperatureValid();
    durationValid();
  }

  void sensorTypeValid() {
    
    sensorTypeError = sensorType.isEmpty;

  }

  void temperatureValid() {
    if (tempUnitCelsius) {
      temperatureError = temperature < 0 || temperature > 100;
    } else {
      temperatureError = temperature < 32 || temperature > 212;
    }
  }

  void durationValid() {
    durationError = duration.inSeconds <= 0;
  }
}
