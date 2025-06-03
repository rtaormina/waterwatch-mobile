import 'package:flutter/material.dart';
import 'package:waterwatch/theme.dart';

class MetricsSelector extends StatefulWidget {
  const MetricsSelector({super.key});

  @override
  State<MetricsSelector> createState() => _MetricsSelectorState();
}

class _MetricsSelectorState extends State<MetricsSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Metric",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(value: false, groupValue: true, onChanged: (val) {}),
                    Text("Temperature", style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
