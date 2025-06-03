import 'package:flutter/material.dart';

class TemperatureInput extends StatefulWidget {
  const TemperatureInput({super.key});

  @override
  State<TemperatureInput> createState() => _TemperatureInputState();
}

class _TemperatureInputState extends State<TemperatureInput> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Temperature",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Sensor Type",
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 1000),
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter temperature",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text("°C")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text("°F")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
