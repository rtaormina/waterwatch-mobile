import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const _kMeasurementsKey = 'stored_measurements';

Future<void> storeMeasurement(
  Map<String, dynamic> measurement,
) async {
  final prefs = await SharedPreferences.getInstance();

  final rawList = prefs.getStringList(_kMeasurementsKey) ?? <String>[];
  rawList.add(jsonEncode(measurement));
  await prefs.setStringList(_kMeasurementsKey, rawList);
}
