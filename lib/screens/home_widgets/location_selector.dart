import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  @override
  Widget build(BuildContext context) {
    return const CardComponent(title: "Map", child: SizedBox());
  }
}
