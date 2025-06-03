import 'package:flutter/material.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/metrics_selector.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
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
        body: Center(
          child: ListView(
            children: [
              const LocationSelector(),
              MetricsSelector(measurementState: widget.measurementState,),
              TemperatureInput(measurementState: widget.measurementState,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [ClearButton(), SubmitButton()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
