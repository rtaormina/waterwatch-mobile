import 'package:latlong2/latlong.dart';
import 'package:waterwatch/util/metric_objects/temperature_object.dart';
import 'package:waterwatch/util/util_functions/format_date_time.dart';
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
