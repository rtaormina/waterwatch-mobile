import 'package:flutter/material.dart';
import 'package:waterwatch/screens/home_widgets/buttons/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/buttons/submit_button.dart';
import 'package:waterwatch/screens/home_widgets/metrics_selector.dart';
import 'package:waterwatch/screens/home_widgets/source_selector.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.measurementState, required this.getLocation});

  final MeasurementState measurementState;
  final Future<void> Function(MeasurementState) getLocation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    widget.measurementState.reloadHomePage = () {
      setState(() {});    };
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
        body: Stack(children: [
          widget.measurementState.showLoading
              ? Container(
                  color: const Color.fromARGB(68, 255, 255, 255),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView(
                        key: const Key('home_list'),
                        shrinkWrap: true,
                        children: [
                          LocationSelector(
                            measurementState: widget.measurementState,
                            getLocation: widget.getLocation,
                          ),
                          SourceSelector(
                            measurementState: widget.measurementState,
                          ),
                          MetricsSelector(
                            measurementState: widget.measurementState,
                            key: const Key('metrics_selector'),
                          ),
                          widget.measurementState.metricTemperature
                              ? TemperatureInput(
                                  key: const Key("temperature_input"),
                                  measurementState: widget.measurementState,
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    keyboardOpen
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClearButton(
                                measurementState: widget.measurementState,
                              ),
                              SubmitButton(
                                  measurementState: widget.measurementState)
                            ],
                          )
                  ],
                ),
        ]),
      ),
    );
  }
}
