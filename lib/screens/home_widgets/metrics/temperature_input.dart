import 'package:flutter/material.dart';
import 'package:waterwatch/components/card_component.dart';
import 'package:waterwatch/theme.dart';
import 'package:waterwatch/util/measurement_state.dart';
import 'package:duration_picker/duration_picker.dart';

class TemperatureInput extends StatefulWidget {
  const TemperatureInput({super.key, required this.measurementState});

  final MeasurementState measurementState;

  @override
  State<TemperatureInput> createState() => _TemperatureInputState();
}

class _TemperatureInputState extends State<TemperatureInput> {
  Duration _dur = const Duration(minutes: 0, seconds: 0);

  @override
  Widget build(BuildContext context) {
    MeasurementState state = widget.measurementState;

    return CardComponent(
      title: "Temperature",
      child: Column(
        children: [
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
              const Expanded(
                child: TextField(
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
                  backgroundColor:
                      state.tempUnitCelsius ? mainColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    state.tempUnitCelsius = true;
                  });
                },
                child: Text(
                  "°C",
                  style: TextStyle(
                    fontSize: 20,
                    color: state.tempUnitCelsius ? Colors.white : mainColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      state.tempUnitCelsius ? Colors.white : mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    state.tempUnitCelsius = false;
                  });
                },
                child: Text(
                  "°F",
                  style: TextStyle(
                    fontSize: 20,
                    color: state.tempUnitCelsius ? mainColor : Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: Text(
              'Duration: '
              '${_dur.inMinutes.remainder(60).toString().padLeft(2, '0')} minutes '
              '${_dur.inSeconds.remainder(60).toString().padLeft(2, '0')} seconds',
              style: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              // Temporarily hold the selected duration in the dialog
              Duration tempDur = _dur;

              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setDialogState) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Select Duration'),
                        content: SizedBox(
                          // Constrain the size of the picker so it doesn’t overflow
                          height: 300,
                          width: 300,
                          child: DurationPicker(
                            baseUnit: BaseUnit.second,
                            duration: tempDur,
                            // Whenever the user scrolls the picker, update tempDur
                            onChange: (val) {
                              setDialogState(() {
                                tempDur = val;
                              });
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Discard changes
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Commit the chosen duration to the parent state
                              setState(() {
                                _dur = tempDur;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          //MinuteSecondPicker(onDurationChanged: (d) {})
        ],
      ),
    );
  }
}
