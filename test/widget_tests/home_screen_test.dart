import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

class FakeMeasurementState extends MeasurementState {
  bool validateCalled = false;
  bool sendDataCalled = false;
  bool cleared = false;
  int reloadCalls = 0;

  FakeMeasurementState() {
    // override the reload callback so we can count how many times it's invoked
    reloadHomePage = () => reloadCalls++;
  }

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

  @override
  void clear() {
    cleared = true;
    super.clear();
  }
}

class InvalidFakeMeasurementState extends FakeMeasurementState {
  @override
  bool validateMetrics() {
    validateCalled = true;
    return false; // simulate invalid input
  }
}

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
    testWidgets('Clearing works', (WidgetTester tester) async {
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
      state.reloadHomePage();
      await tester.pumpAndSettle();
      expect(find.text('Digital Thermometer'), findsOneWidget);
      expect(find.text('23.5'), findsOneWidget);

      // 8. Tap the Clear button
      final clearButtonFinder = find.byType(ClearButton);
      expect(clearButtonFinder, findsOneWidget,
          reason: 'Should find exactly one ClearButton.');
      await tester.tap(clearButtonFinder);
      await tester.pumpAndSettle();

      // 9. After clearing, both fields should be empty
      expect(find.text('23.5'), findsNothing,
          reason:
              'After tapping Clear, the "Enter temperature" field should be empty.');
    });

    testWidgets('Submitting works', (WidgetTester tester) async {
      final fakeState = FakeMeasurementState();
      fakeState.testMode = true;

      //custom location function
      Future<void> mockGetLocation(MeasurementState state) async {
        state.currentLocation = const LatLng(1, 1);
        state.reloadLocation();
      }

      // Define a Widget
      final myWidget = MaterialApp(
        home: HomeScreen(
          measurementState: fakeState,
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

      // 4. Find and fill the Temperature field
      final tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
        description: 'TextField with labelText "Enter temperature"',
      );
      expect(tempField, findsOneWidget);
      await tester.enterText(tempField, '23.5');
      await tester.pumpAndSettle();

      fakeState.metricTemperatureObject.duration = const Duration(seconds: 20);

      // 6. Verify the texts are present
      fakeState.metricTemperatureObject.sensorType = 'Digital Thermometer';
      fakeState.reloadHomePage();
      await tester.pumpAndSettle();
      expect(find.text('Digital Thermometer'), findsOneWidget);
      expect(find.text('23.5'), findsOneWidget);

      // 8. Tap the Clear button
      expect(find.byType(SubmitButton), findsOneWidget);
      final submitButtonFinder = find.byType(SubmitButton);
      await tester.tap(submitButtonFinder);

      // Now let the async work (validate, sendData, clear, second reload) complete:
      await tester.pumpAndSettle();

      // Final assertions:
      expect(fakeState.validateCalled, isTrue,
          reason: 'validateMetrics should run');
      expect(fakeState.sendDataCalled, isTrue,
          reason: 'sendData should run if valid');
      expect(fakeState.cleared, isTrue,
          reason: 'clear() should run after sending');
      expect(fakeState.showLoading, isFalse,
          reason: 'showLoading should be turned off at the end');
    });

    testWidgets('Submitting does not work if incorrect values',
        (WidgetTester tester) async {
      // 1) Use the invalid‐validation fake state
      final fakeState = InvalidFakeMeasurementState();
      fakeState.testMode = true;

      // 2) Stub out location
      Future<void> mockGetLocation(MeasurementState st) async {
        st.currentLocation = const LatLng(1, 1);
        st.reloadLocation();
      }

      // 3) Pump the HomeScreen with our fake state
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            measurementState: fakeState,
            getLocation: mockGetLocation,
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      // 4) Scroll until TemperatureInput is built
      final listFinder = find.byKey(const Key('home_list'));
      await tester.drag(listFinder, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('temperature_input')), findsOneWidget);

      // 5) Fill in the fields (sensor + an out‐of‐range temp of "120")

      final tempField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Enter temperature',
      );
      expect(tempField, findsOneWidget);
      await tester.enterText(tempField, '120');
      await tester.pumpAndSettle();

      // 6) Tap Submit
      final submitFinder = find.byType(SubmitButton);
      expect(submitFinder, findsOneWidget);
      await tester.tap(submitFinder);

      // 7) Let the button's async handler finish
      await tester.pumpAndSettle();

      // 8) Verify invalid path: validate called, but no send or clear
      expect(fakeState.validateCalled, isTrue,
          reason: 'validateMetrics() should be invoked');
      expect(fakeState.sendDataCalled, isFalse,
          reason: 'sendData() should NOT run on invalid input');
      expect(fakeState.cleared, isFalse,
          reason: 'clear() should NOT run on invalid input');

      // And still reset loading & reloaded twice
      expect(fakeState.showLoading, isFalse,
          reason: 'showLoading should end up false');
    });
  });
}
