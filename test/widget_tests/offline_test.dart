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

  group('Offline adding to cache and updating when back online', () {
    testWidgets("should store when not online", (WidgetTester tester) async {
      bool measurementStored = false;
      MeasurementState mockMeasurementState =
          MeasurementState.initializeState(mockOnlineState, () {}, (payload) async {measurementStored = true;});
      Future<void> mockGetLocation(MeasurementState state) async {
        state.currentLocation = const LatLng(1, 1);
        state.reloadLocation();
      }

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
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('network'), findsNothing);
      expect(find.text('Digital Thermometer'), findsNothing);
      expect(find.text('23.5', skipOffstage: false), findsNothing);

      expect(measurementStored, isTrue);
    });
  });
}
