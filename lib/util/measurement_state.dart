class MeasurementState {

  static MeasurementState initializeState() {
    return MeasurementState();
  }

  bool metricTemperature = true;

  void Function() reloadMetricTemperature = () {};

}