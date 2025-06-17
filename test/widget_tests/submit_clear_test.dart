import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
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
    late FakeMeasurementState mockMeasurementState;
    late Future<void> Function(MeasurementState) mockGetLocation;
    late Future<bool> Function() mockGetOnline;

    setUp(() {
      mockGetOnline = () async => false;
      mockMeasurementState = FakeMeasurementState();
      mockGetLocation = (MeasurementState state) async {};
      mockMeasurementState.testMode = true;
      mockMeasurementState.onlineState = mockGetOnline;
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

      Map<String, dynamic> payload = mockMeasurementState.getPayload();
      expect(payload['water_source'], 'network');
      expect(payload['location'], {
        'type': 'Point',
        'coordinates': [1.0, 1.0]
      });
      expect(payload['temperature'], isNotNull);
      expect(payload['temperature']['sensor'], 'Digital Thermometer');
      expect(payload['temperature']['value'], 23.5);
      expect(payload['temperature']['time_waited'], '00:20');

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('network'), findsNothing);
      expect(find.text('Digital Thermometer'), findsNothing);
      expect(find.text('23.5', skipOffstage: false), findsNothing);

      expect(mockMeasurementState.sendDataCalled, isTrue);
    });

    testWidgets('Clear button clears all fields', (WidgetTester tester) async {
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
      var clearButton = find.byType(ClearButton);

      expect(tempInput, findsOneWidget);
      expect(clearButton, findsOneWidget);

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

      mockMeasurementState.reloadHomePage();

      expect(find.text('network', skipOffstage: false), findsOneWidget);
      expect(find.text('Digital Thermometer', skipOffstage: false),
          findsOneWidget);
      expect(find.text('23.5', skipOffstage: false), findsOneWidget);

      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(find.text('network'), findsNothing);
      expect(find.text('Digital Thermometer'), findsNothing);
      expect(find.text('23.5', skipOffstage: false), findsNothing);
    });
  });
}
