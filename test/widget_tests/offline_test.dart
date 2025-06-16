import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  bool online = false;
  Future<bool> mockOnlineState() async {
      return online; // Simulate offline state
    }
  group('Offline adding to cache and updating when back online', () {
    testWidgets("should store when not online", (WidgetTester tester) async {
      MeasurementState state = MeasurementState.initializeState(mockOnlineState);
      Future<void> mockGetLocation(MeasurementState state) async {
        state.currentLocation = const LatLng(1, 1);
        state.reloadLocation();
      }
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(measurementState: state, getLocation: mockGetLocation)
        ),
      );

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

      // 4. Find and fill the Temperature field
      final tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
        description: 'TextField with labelText "Enter temperature"',
      );
      expect(tempField, findsOneWidget);
      await tester.enterText(tempField, '23.5');
      await tester.pumpAndSettle();

      state.metricTemperatureObject.duration = const Duration(seconds: 20);

      // 6. Verify the texts are present
      state.metricTemperatureObject.sensorType = 'Digital Thermometer';
      state.waterSource = 'network';
      state.metricTemperatureObject.temperature = 23.5;
      state.reloadHomePage();
      await tester.pumpAndSettle();
      expect(find.text('Digital Thermometer'), findsOneWidget);
      expect(find.text('network'), findsOneWidget);
      expect(find.text('23.5'), findsOneWidget);

    });
  });
}
