import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  group('Offline adding to cache and updating when back online', () {
    testWidgets("should store when not online", (WidgetTester tester) async {
      MeasurementState state = MeasurementState.initializeState();
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
      state.
    });
  });
}
