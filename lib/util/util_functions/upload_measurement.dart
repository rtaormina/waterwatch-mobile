import 'dart:convert';

import 'package:http/http.dart' as http;
import 'get_csrf_token.dart';

Future<void> uploadMeasurement(
  Map<String, dynamic> measurement,
) async {
  
    String url = "https://waterwatch.tudelft.nl/api/measurements/";
  final uri = Uri.parse(url);

  String token = await getCSRFToken();

  // Optional: set headers
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Referer': 'https://waterwatch.tudelft.nl',
    'X-CSRFToken': token,
    'Cookie': 'csrftoken=$token',
  };

  final body = jsonEncode(measurement);

  final response = await http.post(uri, headers: headers, body: body);

  if (response.statusCode != 200 && response.statusCode != 201) {
    
    throw http.ClientException(
      'Failed POST (${response.statusCode}): ${response.body}',
      uri,
    );
  }
  
  
}
