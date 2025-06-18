import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:waterwatch/util/measurement_state.dart';

class MetricsSelector extends StatefulWidget {
  const MetricsSelector({super.key, required this.measurementState});

  final MeasurementState measurementState;

  @override
  State<MetricsSelector> createState() => _MetricsSelectorState();
}

class _MetricsSelectorState extends State<MetricsSelector> {
  @override
  Widget build(BuildContext context) {
    MeasurementState state = widget.measurementState;

    return CardComponent(
        title: "Metric",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                value: state.metricTemperature,
                onChanged: (val) {
                  setState(() {
                    state.metricTemperature = !state.metricTemperature;
                    state.reloadHomePage();
                  });
                }),
            const Text("Temperature", style: TextStyle(fontSize: 16)),
          ],
        ));
  }
}
