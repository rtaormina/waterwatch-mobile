import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/util/measurement_state.dart';

void main() {
  group('SourceSelector Widget Tests', () {
    late MeasurementState mockMeasurementState;

    setUp(() {
      mockMeasurementState = MeasurementState.initializeState(
        () async => false,
        () {},
        (payload) async {},
        (payload) async {},
      );
    });

    testWidgets('should display hint text when no value is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      expect(find.text('Select water source'), findsOneWidget);
      expect(find.text('Water Source'), findsOneWidget);
    });

    testWidgets('should display all dropdown options when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Tap the dropdown to open it
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Verify all options are present
      expect(find.text('network'), findsOneWidget);
      expect(find.text('rooftop tank'), findsOneWidget);
      expect(find.text('well'), findsOneWidget);
      expect(find.text('other'), findsOneWidget);
    });

    testWidgets('should select and display network option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Open dropdown and select 'network'
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('network').last);
      await tester.pumpAndSettle();

      // Verify the selection
      expect(mockMeasurementState.waterSource, equals('network'));
      expect(find.text('network'), findsOneWidget);
      expect(find.text('Select water source'), findsNothing);
    });

    testWidgets('should select and display rooftop tank option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Open dropdown and select 'rooftop tank'
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('rooftop tank').last);
      await tester.pumpAndSettle();

      // Verify the selection
      expect(mockMeasurementState.waterSource, equals('rooftop tank'));
      expect(find.text('rooftop tank'), findsOneWidget);
      expect(find.text('Select water source'), findsNothing);
    });

    testWidgets('should select and display well option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Open dropdown and select 'well'
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('well').last);
      await tester.pumpAndSettle();

      // Verify the selection
      expect(mockMeasurementState.waterSource, equals('well'));
      expect(find.text('well'), findsOneWidget);
      expect(find.text('Select water source'), findsNothing);
    });

    testWidgets('should select and display other option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Open dropdown and select 'other'
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('other').last);
      await tester.pumpAndSettle();

      // Verify the selection
      expect(mockMeasurementState.waterSource, equals('other'));
      expect(find.text('other'), findsOneWidget);
      expect(find.text('Select water source'), findsNothing);
    });

    testWidgets('should switch between different selections',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // First select 'network'
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('network').last);
      await tester.pumpAndSettle();

      expect(mockMeasurementState.waterSource, equals('network'));
      expect(find.text('network'), findsOneWidget);

      // Then switch to 'well'
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('well').last);
      await tester.pumpAndSettle();

      expect(mockMeasurementState.waterSource, equals('well'));
      expect(find.text('well'), findsOneWidget);
      expect(find.text('network'), findsNothing);
    });

    testWidgets(
        'should show hint text after measurementState.clear() is called',
        (WidgetTester tester) async {
      // First set a value
      mockMeasurementState.waterSource = 'network';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Verify the selected value is displayed
      expect(find.text('network'), findsOneWidget);
      expect(find.text('Select water source'), findsNothing);

      // Clear the measurement state
      mockMeasurementState.clear();

      // Rebuild the widget to reflect the state change
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Verify hint text is now shown
      expect(find.text('Select water source'), findsOneWidget);
      expect(find.text('network'), findsNothing);
      expect(mockMeasurementState.waterSource, isNull);
    });

    testWidgets('should maintain state across widget rebuilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Select a value
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('rooftop tank').last);
      await tester.pumpAndSettle();

      expect(mockMeasurementState.waterSource, equals('rooftop tank'));

      // Rebuild the widget with the same measurementState
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SourceSelector(measurementState: mockMeasurementState),
          ),
        ),
      );

      // Verify the selection is maintained
      expect(find.text('rooftop tank'), findsOneWidget);
      expect(mockMeasurementState.waterSource, equals('rooftop tank'));
    });
  });
}
