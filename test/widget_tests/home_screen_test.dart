import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/metrics_selector.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('Homescreen loads and temperature metric selection works',
        (WidgetTester tester) async {
      // Define a Widget
      final myWidget = MaterialApp(
          home:
              HomeScreen(measurementState: MeasurementState.initializeState()));

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);
      await tester.pumpAndSettle();
      // Verify myWidget shows some text
      expect(find.byType(LocationSelector), findsOneWidget);
      expect(find.byType(SourceSelector), findsOneWidget);
      expect(find.byType(MetricsSelector), findsOneWidget);
      expect(find.byType(TemperatureInput), findsOneWidget);

      // Temperature metric button
      final temperatureCheckbox = find.byType(Checkbox).first;
      await tester.tap(temperatureCheckbox);
      await tester.pumpAndSettle();
      expect(find.byType(TemperatureInput), findsNothing);
    });
  });

  // group('TemperatureInput + Submit/Clear behavior', () {
  //   testWidgets(
  //     'entering text and tapping Submit leaves fields intact; tapping Clear empties them',
  //     (WidgetTester tester) async {
  //       // 1) Prepare a MeasurementState with metricTemperature = true
  //       final measurementState = MeasurementState.initializeState();

  //       // 2) Pump HomeScreen inside a MaterialApp
  //       await tester.pumpWidget(
  //         MaterialApp(
  //           home: HomeScreen(measurementState: measurementState),
  //         ),
  //       );
  //       await tester.pumpAndSettle();

  //       // 3) Find the two TextFields by their labelText
  //       final sensorFieldFinder = find.byWidgetPredicate(
  //         (widget) {
  //           return widget is TextField &&
  //               widget.decoration?.labelText == 'Sensor Type';
  //         },
  //         description: 'TextField with labelText "Sensor Type"',
  //       );
  //       final tempFieldFinder = find.byWidgetPredicate(
  //         (widget) {
  //           return widget is TextField &&
  //               widget.decoration?.labelText == 'Enter temperature';
  //         },
  //         description: 'TextField with labelText "Enter temperature"',
  //       );

  //       expect(sensorFieldFinder, findsOneWidget,
  //           reason: 'Should find exactly one TextField labeled "Sensor Type".');
  //       expect(tempFieldFinder, findsOneWidget,
  //           reason:
  //               'Should find exactly one TextField labeled "Enter temperature".');

  //       // 4) Enter some text into each field
  //       await tester.enterText(sensorFieldFinder, 'MySensor');
  //       await tester.enterText(tempFieldFinder, '25');
  //       await tester.pumpAndSettle();

  //       // Verify the text actually appears in the widget tree
  //       expect(find.text('MySensor'), findsOneWidget);
  //       expect(find.text('25'), findsOneWidget);

  //       // 5) Tap the SubmitButton
  //       final submitButtonFinder = find.byType(SubmitButton);
  //       expect(submitButtonFinder, findsOneWidget,
  //           reason: 'SubmitButton should be present below the list.');
  //       await tester.tap(submitButtonFinder);
  //       await tester.pumpAndSettle();

  //       // Since functionality is not implemented yet, we expect the text to remain
  //       expect(find.text('MySensor'), findsOneWidget,
  //           reason:
  //               'Tapping Submit (unimplemented) should not clear the fields yet.');
  //       expect(find.text('25'), findsOneWidget);

  //       // 6) Tap the ClearButton
  //       final clearButtonFinder = find.byType(ClearButton);
  //       expect(clearButtonFinder, findsOneWidget,
  //           reason: 'ClearButton should be present next to SubmitButton.');
  //       await tester.tap(clearButtonFinder);
  //       await tester.pumpAndSettle();

  //       // Now both fields should be empty (no lingering text)
  //       expect(find.text('MySensor'), findsNothing,
  //           reason:
  //               'After tapping Clear, the "Sensor Type" field should be empty.');
  //       expect(find.text('25'), findsNothing,
  //           reason:
  //               'After tapping Clear, the "Enter temperature" field should be empty.');
  //     },
  //   );
  // });
}
