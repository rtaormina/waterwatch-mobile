import 'package:flutter/material.dart';
import 'package:waterwatch/theme.dart';

class TemperatureInput extends StatefulWidget {
  const TemperatureInput({super.key});

  @override
  State<TemperatureInput> createState() => _TemperatureInputState();
}

class _TemperatureInputState extends State<TemperatureInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: secondaryColor,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Temperature",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                  Expanded(
                    child: const TextField(
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "°C",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                  const SizedBox(width: 10),
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
          ),
        ),
      ),
    );
  }
}
