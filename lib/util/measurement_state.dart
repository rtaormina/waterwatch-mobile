import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';

class MeasurementState {

  //create a new instance of MeasurementState
  static MeasurementState initializeState() {
    return MeasurementState();
  }

  //general measurement state
  String waterSource = 'River';
  LatLng location = const LatLng(0, 0);

  //selected metrics
  bool metricTemperature = true;
  TemperatureObject metricTemperatureObject = TemperatureObject();

  //reload function for home page
  void Function() reloadHomePage = () {};

  //validating all metrics
  void validateMetrics() {
    metricTemperatureObject.validate();
  }
}