class MeasurementState {
  static MeasurementState initializeState() {
    return MeasurementState();
  }

  bool metricTemperature = true;
  bool tempUnitCelsius = true;

  String waterSource = 'River';

  void Function() reloadHomePage = () {};
}
