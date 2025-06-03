import 'package:flutter/material.dart';

class MetricsSelector extends StatefulWidget {
  const MetricsSelector({super.key});

  @override
  State<MetricsSelector> createState() => _MetricsSelectorState();
}

class _MetricsSelectorState extends State<MetricsSelector> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(
          "Metrics",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            
          ),

        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio(value: false, groupValue: true, onChanged: (val) {}),
            Text("Temperature", style: TextStyle(fontSize: 16)),
          ],) 
      ],)
    );
  }
}
