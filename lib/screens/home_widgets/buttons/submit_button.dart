import 'package:flutter/material.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.measurementState});
  final MeasurementState measurementState;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              elevation: 0.0,
              side: BorderSide(color: mainColor, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              print("Submit button pressed");
              measurementState.validateMetrics();
              measurementState.sendData();
              measurementState.clear();
              measurementState.reloadHomePage();
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
      ),
    );
  }
}
