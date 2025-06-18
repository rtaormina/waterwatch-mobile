import 'package:http/http.dart' as client;

Future<String> getCSRFToken({client.Client? httpClient}) async {
  final c = httpClient ?? client.Client();
  final uri = Uri.parse('https://waterwatch.tudelft.nl/api/session/');
  final response = await c.get(uri, headers: {
    'Accept': 'application/json',
    'Referer': 'https://waterwatch.tudelft.nl',
  });

  final setCookie = response.headers['set-cookie'];
  if (setCookie == null) {
    throw Exception('Missing Set-Cookie header when fetching CSRF token');
  }
  final csrfPair = setCookie
      .split(';')
      .firstWhere((seg) => seg.trim().startsWith('csrftoken='));
  final token = csrfPair.split('=')[1];
  return token;
}
