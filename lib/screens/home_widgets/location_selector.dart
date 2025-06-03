import 'package:flutter/material.dart';
import 'package:waterwatch/theme.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: secondaryColor,
        child: Container(
          color: Colors.blue[100],
          child: Center(
            child: Text("Map"),
          ),
        ),
      ),
    );
  }
}
