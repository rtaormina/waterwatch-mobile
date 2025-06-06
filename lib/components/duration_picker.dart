import 'package:flutter/material.dart';

class MinuteSecondPicker extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;
  final ValueChanged<Duration> onDurationChanged;

  const MinuteSecondPicker({
    super.key,
    this.initialMinutes = 0,
    this.initialSeconds = 0,
    required this.onDurationChanged,
  });

  @override
  State<MinuteSecondPicker> createState() => _MinuteSecondPickerState();
}

class _MinuteSecondPickerState extends State<MinuteSecondPicker> {
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialMinutes;
    _seconds = widget.initialSeconds;
  }

  void _fireChange() {
    widget.onDurationChanged(Duration(minutes: _minutes, seconds: _seconds));
  }

  @override
  Widget build(BuildContext context) {
    // Create lists [0, 1, 2, …, 59]
    final minuteItems = List<DropdownMenuItem<int>>.generate(
      60,
      (i) => DropdownMenuItem(value: i, child: Text(i.toString())),
    );
    final secondItems = minuteItems; // same 0–59

    return Row(
      children: [
        // Minutes dropdown
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'Min',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            child: DropdownButton<int>(
              dropdownColor: Colors.white,
              isExpanded: true,
              value: _minutes,
              items: minuteItems,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  _minutes = val;
                  _fireChange();
                });
              },
              underline: const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Seconds dropdown
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'Sec',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            child: DropdownButton<int>(
              dropdownColor: Colors.white,
              isExpanded: true,
              value: _seconds,
              items: secondItems,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  _seconds = val;
                  _fireChange();
                });
              },
              underline: const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
