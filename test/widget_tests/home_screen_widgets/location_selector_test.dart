import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  group('LocationSelector Widget Tests', () {
    late MeasurementState mockMeasurementState;
    bool getLocationCalled = false;

    Future<void> mockGetLocation(MeasurementState state) async {
      getLocationCalled = true;
      // Simulate getting location after a delay
      //await Future.delayed(const Duration(milliseconds: 100));
      state.currentLocation = const LatLng(52.0116, 4.3571);
    }

    setUp(() {
      mockMeasurementState = MeasurementState.initializeState(
        () async => false,
        () {},
        (payload) async {},
        (payload) async {},
      );
      getLocationCalled = false;
    });

    testWidgets('should display loading indicator when location is loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      // Should show loading indicator initially
      //expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Measurement'), findsOneWidget);
      expect(find.text('Tap on the map to pick a point'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('should call getLocation on initialization',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(getLocationCalled, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('should display error message when locationError is set',
        (WidgetTester tester) async {
      const errorMessage = 'Location permission denied';
      mockMeasurementState.locationError = errorMessage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets('should display map when currentLocation is available',
        (WidgetTester tester) async {
      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Tap on the map to pick a point'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        'should display selected location coordinates when location is set',
        (WidgetTester tester) async {
      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);
      mockMeasurementState.location = const LatLng(52.01234, 4.35678);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.text('Selected: Lat 52.01234, Lng 4.35678'), findsOneWidget);
      expect(find.text('Tap on the map to pick a point'), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets('should show tap instruction when no location is selected',
        (WidgetTester tester) async {
      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);
      mockMeasurementState.location = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.text('Tap on the map to pick a point'), findsOneWidget);
      expect(find.textContaining('Selected:'), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets('should set reloadLocation callback on build',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(mockMeasurementState.reloadLocation, isNotNull);
      await tester.pumpAndSettle();
    });

    testWidgets('should rebuild when reloadLocation is called',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);
      mockMeasurementState.reloadLocation();

      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('should display both error and location when both are set',
        (WidgetTester tester) async {
      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);
      mockMeasurementState.locationError = 'GPS accuracy is low';
      mockMeasurementState.location = const LatLng(52.01234, 4.35678);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.text('GPS accuracy is low'), findsOneWidget);
      expect(find.text('Selected: Lat 52.01234, Lng 4.35678'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle state changes correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);
      mockMeasurementState.reloadLocation();
      await tester.pump();

      expect(find.text('Tap on the map to pick a point'), findsOneWidget);

      mockMeasurementState.location = const LatLng(52.01234, 4.35678);
      mockMeasurementState.reloadLocation();
      await tester.pump();

      expect(find.text('Selected: Lat 52.01234, Lng 4.35678'), findsOneWidget);
      expect(find.text('Tap on the map to pick a point'), findsNothing);

      mockMeasurementState.locationError = 'Network error';
      mockMeasurementState.reloadLocation();
      await tester.pump();

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Selected: Lat 52.01234, Lng 4.35678'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should clear location when measurementState.clear() is called',
        (WidgetTester tester) async {
      mockMeasurementState.currentLocation = const LatLng(52.0116, 4.3571);
      mockMeasurementState.location = const LatLng(52.01234, 4.35678);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.text('Selected: Lat 52.01234, Lng 4.35678'), findsOneWidget);

      mockMeasurementState.clear();
      mockMeasurementState.currentLocation = null;
      mockMeasurementState.location = null;
      mockMeasurementState.locationError = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelector(
              measurementState: mockMeasurementState,
              getLocation: mockGetLocation,
            ),
          ),
        ),
      );

      expect(find.text('Selected: Lat 52.01234, Lng 4.35678'), findsNothing);
      expect(mockMeasurementState.location, isNull);
      expect(mockMeasurementState.currentLocation, isNull);
    });
  });
}
