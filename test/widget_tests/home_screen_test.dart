import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('Homescreen loads and temperature metric selection works',
        (WidgetTester tester) async {
      MeasurementState state = MeasurementState.initializeState();
      state.testMode = true;

      //custom location function
      Future<void> mockGetLocation(MeasurementState state) async {
        state.currentLocation = const LatLng(1, 1);
        state.reloadLocation();
      }

      // Define a Widget
      final myWidget = MaterialApp(
        home: HomeScreen(
          measurementState: state,
          getLocation: mockGetLocation,
        ),
      );

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);

      await tester.pump(); // extra pump to process any microtasks
      await tester.pumpAndSettle();

      // Verify myWidget shows some text
      expect(find.byType(LocationSelector), findsOneWidget);
      expect(find.byType(SourceSelector), findsOneWidget);

      // first make sure the list is built
      await tester.pumpAndSettle();

      // After pumpAndSettle():
      final listFinder = find.byKey(const Key('home_list'));

      // Drag upward by 200 pixels to bring more children into view:
      await tester.drag(listFinder, const Offset(0, -200));
      await tester.pumpAndSettle();

      // Now MetricsSelector will have been built:
      expect(find.byKey(const Key('metrics_selector')), findsOneWidget);

      // And you can drag again for the TemperatureInput:
      await tester.drag(listFinder, const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('temperature_input')), findsOneWidget);

      // Temperature metric button
      final temperatureCheckbox = find.byType(Checkbox).first;
      await tester.tap(temperatureCheckbox);
      await tester.pumpAndSettle();
      expect(find.byType(TemperatureInput), findsNothing);
    });
  });

  group('TemperatureInput + Submit/Clear behavior', () {
    testWidgets('Homescreen loads and temperature metric selection works',
        (WidgetTester tester) async {
      MeasurementState state = MeasurementState.initializeState();
      state.testMode = true;

      //custom location function
      Future<void> mockGetLocation(MeasurementState state) async {
        state.currentLocation = const LatLng(1, 1);
        state.reloadLocation();
      }

      // Define a Widget
      final myWidget = MaterialApp(
        home: HomeScreen(
          measurementState: state,
          getLocation: mockGetLocation,
        ),
      );

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);

      await tester.pump(); // extra pump to process any microtasks
      await tester.pumpAndSettle();

      // Verify myWidget shows some text
      expect(find.byType(LocationSelector), findsOneWidget);
      expect(find.byType(SourceSelector), findsOneWidget);

      // first make sure the list is built
      await tester.pumpAndSettle();

      // After pumpAndSettle():
      final listFinder = find.byKey(const Key('home_list'));

      // Drag upward by 200 pixels to bring more children into view:
      await tester.drag(listFinder, const Offset(0, -400));
      await tester.pumpAndSettle();

      // Now MetricsSelector will have been built:
      expect(find.byKey(const Key('temperature_input')), findsOneWidget);

      // 3. Find and fill the Sensor Type field
      final sensorTypeField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Sensor Type',
        description: 'TextField with labelText "Sensor Type"',
      );
      expect(sensorTypeField, findsOneWidget);
      await tester.enterText(sensorTypeField, 'MySensor');
      await tester.pumpAndSettle();

      // 4. Find and fill the Temperature field
      final tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
        description: 'TextField with labelText "Enter temperature"',
      );
      expect(tempField, findsOneWidget);
      await tester.enterText(tempField, '23.5');
      await tester.pumpAndSettle();

      state.metricTemperatureObject.duration = Duration(seconds: 20);

      // 6. Verify the texts are present
      expect(find.text('MySensor'), findsOneWidget);
      expect(find.text('23.5'), findsOneWidget);
    });
  });
}
