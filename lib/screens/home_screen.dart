import 'package:flutter/material.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/metrics_selector.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.measurementState});

  final MeasurementState measurementState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          //backround collor defined by hex
          backgroundColor: mainColor,
          title: const Text(
            'WATERWATCH',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 30),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                children: [
                  const LocationSelector(),
                  SourceSelector(
                    measurementState: widget.measurementState,
                  ),
                  MetricsSelector(
                    measurementState: widget.measurementState,
                  ),
                  TemperatureInput(
                    measurementState: widget.measurementState,
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
            keyboardOpen
                ? const SizedBox()
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ClearButton(), SubmitButton()],
                  )
          ],
        ),
      ),
    );
  }
}
