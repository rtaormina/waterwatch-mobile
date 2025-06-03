import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class TemperatureInput extends StatefulWidget {
  const TemperatureInput({super.key, required this.measurementState});

  final MeasurementState measurementState;

  @override
  State<TemperatureInput> createState() => _TemperatureInputState();
}

class _TemperatureInputState extends State<TemperatureInput> {
  @override
  Widget build(BuildContext context) {
    MeasurementState state = widget.measurementState;
    state.reloadMetricTemperature = () => setState(() {});
    return
        // If metricTemperature is true, show the temperature input card, else an empty SizedBox
        state.metricTemperature
            ? CardComponent(
                title: "Temperature",
                child: Column(
                  children: [
                    // TextField for sensor type input
                    const TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: "Sensor Type",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // TextField for temperature input
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: "Enter temperature",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Button for Celsius
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "°C",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                        const SizedBox(width: 10),
                        // Button for Fahrenheit
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {},
                          child: Text("°F",
                              style: TextStyle(fontSize: 20, color: mainColor)),
                        )
                      ],
                    ),
                  ],
                ))
            : const SizedBox();
  }
}
