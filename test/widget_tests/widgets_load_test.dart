import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/screens/home_widgets/metrics_selector.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late MeasurementState mockMeasurementState;
    late Future<void> Function(MeasurementState) mockGetLocation;
    late Future<bool> Function() mockGetOnline;

    setUp(() {
      // Create a mock measurement state with default values
      mockGetOnline = () async => false; // Mock online state
      mockMeasurementState = MeasurementState.initializeState(mockGetOnline, () {}, (payload) async {});
      mockGetLocation = (MeasurementState state) async {
        // Mock implementation
      };
    });

    testWidgets('HomeScreen loads and displays all main components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that the main scaffold loads
      expect(find.byType(Scaffold), findsOneWidget);

      // Test that the app bar loads with correct title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('WATERWATCH'), findsOneWidget);

      // Test that the main ListView loads
      expect(find.byKey(const Key('home_list')), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('LocationSelector widget loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that LocationSelector is present
      expect(find.byType(LocationSelector), findsOneWidget);
    });

    testWidgets('SourceSelector widget loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that SourceSelector is present
      expect(find.byType(SourceSelector), findsOneWidget);
    });

    testWidgets('MetricsSelector widget loads with correct key',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that MetricsSelector is present
      expect(find.byType(MetricsSelector, skipOffstage: false), findsOneWidget);
      expect(find.byKey(const Key('metrics_selector'), skipOffstage: false),
          findsOneWidget);
    });

    testWidgets('TemperatureInput shows when metricTemperature is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      await tester.drag(find.byType(ListView), Offset(0, -300));
      await tester.pump();

      // Test that TemperatureInput is present when metricTemperature is true
      expect(
          find.byType(TemperatureInput, skipOffstage: false), findsOneWidget);
      expect(find.byKey(const Key('temperature_input'), skipOffstage: false),
          findsOneWidget);
    });

    testWidgets('TemperatureInput hidden when metricTemperature is false',
        (WidgetTester tester) async {
      // Set metricTemperature to false
      mockMeasurementState.metricTemperature = false;

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      await tester.drag(find.byType(ListView), Offset(0, -300));
      await tester.pump();

      // Test that TemperatureInput is not present when metricTemperature is false
      expect(find.byType(TemperatureInput, skipOffstage: false), findsNothing);
      expect(find.byKey(const Key('temperature_input'), skipOffstage: false),
          findsNothing);
    });

    testWidgets(
        'Action buttons (Clear and Submit) load when keyboard is closed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that both buttons are present
      expect(find.byType(ClearButton), findsOneWidget);
      expect(find.byType(SubmitButton), findsOneWidget);

      // Test that they are in a Row
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('Loading indicator shows when showLoading is true',
        (WidgetTester tester) async {
      // Set showLoading to true
      mockMeasurementState.showLoading = true;

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that CircularProgressIndicator is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Error dialog shows when showError is called',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Trigger the error dialog
      mockMeasurementState.showError('Test error message');
      await tester.pump();

      // Test that error dialog is present
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('Error dialog can be dismissed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Trigger the error dialog
      mockMeasurementState.showError('Test error message');
      await tester.pump();

      // Tap the OK button
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Test that dialog is dismissed
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('State management callbacks are properly set',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: mockMeasurementState,
            getLocation: mockGetLocation,
          ),
        ),
      );

      // Test that callbacks are set
      expect(mockMeasurementState.reloadHomePage, isNotNull);
      expect(mockMeasurementState.showError, isNotNull);
    });
  });
}
