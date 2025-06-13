import 'package:flutter/material.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key, required this.measurementState});

  final MeasurementState measurementState;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              measurementState.clear();
              measurementState.reloadHomePage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0.0,
              side: BorderSide(color: mainColor, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text("Clear",
                style: TextStyle(fontSize: 20, color: mainColor))),
      ),
    );
  }
}
