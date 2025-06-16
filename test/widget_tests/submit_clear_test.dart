import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

class FakeMeasurementState extends MeasurementState {
  bool validateCalled = false;
  bool sendDataCalled = false;

  @override
  bool validateMetrics() {
    validateCalled = true;
    return true; // simulate “valid” input
  }

  @override
  Future<Map<String, dynamic>> sendData() async {
    sendDataCalled = true;
    // simulate a quick network call
    return <String, dynamic>{};
  }
}

void main() {
  group('Submit and clear', () {
    late MeasurementState mockMeasurementState;
    late Future<void> Function(MeasurementState) mockGetLocation;
    late Future<bool> Function() mockGetOnline;

    setUp(() {
      mockGetOnline = () async => false;
      mockMeasurementState =
          MeasurementState.initializeState(mockGetOnline, () {});
      mockGetLocation = (MeasurementState state) async {};
      mockMeasurementState.testMode = true;
    });

    testWidgets('Submitting workflow', (WidgetTester tester) async {
      // Define a Widget
      final myWidget = MaterialApp(
        home: HomeScreen(
          measurementState: mockMeasurementState,
          getLocation: mockGetLocation,
        ),
      );

      await tester.pumpWidget(myWidget);

      await tester.drag(find.byType(ListView), Offset(0, -300));
      await tester.pump();

      var tempInput = find.byKey(const Key('temperature_input'));
      var submitButton = find.byType(SubmitButton);
      var clearButton = find.byType(ClearButton);

      expect(tempInput, findsOneWidget);
      expect(submitButton, findsOneWidget);
      expect(clearButton, findsOneWidget);

      var tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
        description: 'TextField with labelText "Enter temperature"',
      );

      mockMeasurementState.waterSource = 'network';
      mockMeasurementState.currentLocation = const LatLng(1, 1);
      mockMeasurementState.metricTemperatureObject.sensorType = 'Digital Thermometer';
      mockMeasurementState.metricTemperatureObject.duration = const Duration(seconds: 20);

      tester.enterText(tempField, '23.5');

    });
  });
}
