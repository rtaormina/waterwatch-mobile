import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:waterwatch/util/measurement_state.dart';

class SourceSelector extends StatefulWidget {
  const SourceSelector({super.key, required this.measurementState});

  final MeasurementState measurementState;

  @override
  State<SourceSelector> createState() => _SourceSelectorState();
}

class _SourceSelectorState extends State<SourceSelector> {
  @override
  Widget build(BuildContext context) {
    return CardComponent(
        title: "Water source",
        child: InputDecorator(
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
          child: DropdownButton<String>(
            underline: const SizedBox(),
            isExpanded: true,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            dropdownColor: Colors.white,
            value: widget.measurementState.waterSource,
            items: <String>['network', 'rooftop tank', 'well', 'other']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.measurementState.waterSource = newValue!;
              });
            },
          ),
        ));
  }
}
