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

  @override
  Widget build(BuildContext context) {
    MeasurementState state = widget.measurementState;

    return CardComponent(
      title: "Temperature",
      child: Column(
        children: [
          TextField(
            controller: widget
                .measurementState.metricTemperatureObject.sensorController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: state.metricTemperatureObject.sensorTypeError
                          ? Colors.red
                          : Colors.black)),
              labelText: "Sensor Type",
              errorText: state.metricTemperatureObject.sensorTypeError
                  ? 'Please enter a sensor type'
                  : null,
            ),
            onChanged: (value) {
              state.metricTemperatureObject.sensorType = value;
            },
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.measurementState.metricTemperatureObject
                      .temperatureController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                state.metricTemperatureObject.temperatureError
                                    ? Colors.red
                                    : Colors.black)),
                    labelText: "Enter temperature",
                    errorText: state.metricTemperatureObject.temperatureError
                        ? 'Enter a valid temperature'
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    state.metricTemperatureObject.temperature =
                        double.tryParse(val) ?? 0.0;
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: state.metricTemperatureObject.tempUnitCelsius
                      ? mainColor
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    state.metricTemperatureObject.tempUnitCelsius = true;
                  });
                },
                child: Text(
                  "°C",
                  style: TextStyle(
                    fontSize: 20,
                    color: state.metricTemperatureObject.tempUnitCelsius
                        ? Colors.white
                        : mainColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: state.metricTemperatureObject.tempUnitCelsius
                      ? Colors.white
                      : mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    state.metricTemperatureObject.tempUnitCelsius = false;
                  });
                },
                child: Text(
                  "°F",
                  style: TextStyle(
                    fontSize: 20,
                    color: state.metricTemperatureObject.tempUnitCelsius
                        ? mainColor
                        : Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: Text(
              'Duration: '
              '${state.metricTemperatureObject.duration.inMinutes.remainder(60).toString().padLeft(2, '0')} minutes '
              '${state.metricTemperatureObject.duration.inSeconds.remainder(60).toString().padLeft(2, '0')} seconds',
              style: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              // Temporarily hold the selected duration in the dialog
              Duration tempDur = state.metricTemperatureObject.duration;

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
                                widget.measurementState.metricTemperatureObject
                                    .duration = val;
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
                                state.metricTemperatureObject.duration = tempDur;
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
          widget.measurementState.metricTemperatureObject.durationError
              ? const Text(
                  "Please pick a duration",
                  style: TextStyle(color: Colors.red),
                )
              : const SizedBox()
          //MinuteSecondPicker(onDurationChanged: (d) {})
        ],
      ),
    );
  }
}
