import 'package:flutter/material.dart';
import 'package:waterwatch/screens/home_screen.dart';
import 'package:waterwatch/util/measurement_state.dart';
import 'package:waterwatch/util/util_functions/get_location.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xFF00A6D6,
            <int, Color>{
              50: Color(0xFFE1F5FE),
              100: Color(0xFFB3E5FC),
              200: Color(0xFF81D4FA),
              300: Color(0xFF4FC3F7),
              400: Color(0xFF29B6F6),
              500: Color(0xFF00A6D6),
              600: Color(0xFF0091EA),
              700: Color(0xFF0081CB),
              800: Color(0xFF0072B8),
              900: Color(0xFF006064),
            },
          ),
          // Optionally specify a custom brightness (dark/light)
          brightness: Brightness.light,
        ).copyWith(
          secondary: const Color(0xFFD7E9F4), // ← this is your “accent” color
        ),
      ),
      home: HomeScreen(measurementState: MeasurementState.initializeState(), getLocation: fetchDeviceLocation,),
    ),
  );
}
