import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/util/measurement_state.dart';



void main() {
  bool online = false;
  Future<bool> mockOnlineState() async {
    return online; // Simulate offline state
  }

  group('Offline adding to cache', () {
    testWidgets("should store when not online", (WidgetTester tester) async {
      bool measurementStored = false;
      bool measurementSent = false;
      MeasurementState mockMeasurementState =
          MeasurementState.initializeState(mockOnlineState, () {}, (payload) async {measurementStored = true;}, (payload) async {measurementSent = true;});
      mockMeasurementState.testMode = true;

      final myWidget = MaterialApp(
        home: HomeScreen(
          measurementState: mockMeasurementState,
          getLocation: (MeasurementState state) async {},
        ),
      );

      await tester.pumpWidget(myWidget);

      await tester.drag(find.byType(ListView), Offset(0, -300));
      await tester.pump();

      var tempInput = find.byKey(const Key('temperature_input'));
      var submitButton = find.byType(SubmitButton);

      expect(tempInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      var tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
        description: 'TextField with labelText "Enter temperature"',
      );

      mockMeasurementState.waterSource = 'network';
      mockMeasurementState.currentLocation = const LatLng(1, 1);
      mockMeasurementState.location = const LatLng(1, 1);
      mockMeasurementState.metricTemperatureObject.sensorType =
          'Digital Thermometer';
      mockMeasurementState.metricTemperatureObject.duration =
          const Duration(seconds: 20);

      await tester.enterText(tempField, '23.5');

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('network'), findsNothing);
      expect(find.text('Digital Thermometer'), findsNothing);
      expect(find.text('23.5', skipOffstage: false), findsNothing);

      expect(measurementStored, isTrue);
      expect(measurementSent, isFalse); 
    });
  });
}
