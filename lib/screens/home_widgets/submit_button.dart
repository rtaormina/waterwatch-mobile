import 'package:flutter/material.dart';
import 'package:waterwatch/theme.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

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
            onPressed: () {},
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
      ),
    );
  }
}
