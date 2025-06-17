// integration_test/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/util/measurement_state.dart';
import 'package:waterwatch/util/util_functions/get_location.dart';
import 'package:waterwatch/util/util_functions/is_online.dart';
import 'package:waterwatch/util/util_functions/store_measurement.dart';
import 'package:waterwatch/util/util_functions/upload_measurement.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen integration tests', () {
    late MeasurementState measurementState;

    // A fake getLocation that immediately sets a location and triggers a rebuild
    Future<void> mockGetLocation(MeasurementState state) async {
      state.currentLocation = LatLng(50.0, 8.0);
      state.reloadLocation();
    }

    setUp(() {
      measurementState = MeasurementState.initializeState(
        getOnline,
        startMonitoring,
        storeMeasurement,
        uploadMeasurement,
      );
    });

    testWidgets('shows loading indicator then the map', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: measurementState,
            getLocation: getLocation,
          ),
        ),
      );

      // 1) Spinner while waiting for mockGetLocation
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 2) After getLocation completes, spinner disappears and map shows
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('submitting with no source shows error dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: measurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the "Submit" button
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Should see your AlertDialog
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Please select a water source.'), findsOneWidget);

      // Dismiss it
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsNothing);
    });

    testWidgets('toggling metric temperature hides/shows temperature input',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: measurementState,
            getLocation: getLocation,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      final listFinder = find.byKey(const Key('home_list')); 
    
      await tester.flingFrom(Offset(200, 500), const Offset(0, -200), 1000);


      await Future.delayed(const Duration(seconds: 2));

     


      var tempInput = find.byKey(const Key('temperature_input'));
      var submitButton = find.byType(SubmitButton);

      expect(tempInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      var tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
        description: 'TextField with labelText "Enter temperature"',
      );

      measurementState.waterSource = 'network';
      measurementState.currentLocation = const LatLng(1, 1);
      measurementState.location = const LatLng(1, 1);
      measurementState.metricTemperatureObject.sensorType =
          'Digital Thermometer';
      measurementState.metricTemperatureObject.duration =
          const Duration(seconds: 20);

      await tester.enterText(tempField, '23.5');

      Map<String, dynamic> payload = measurementState.getPayload();
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
    });
  });
}
