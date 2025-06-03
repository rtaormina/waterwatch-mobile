import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        
        color: Colors.blue[100],
        child: Center(
          child: Text("Map"),
        ),
      ),
    );
  }
}
