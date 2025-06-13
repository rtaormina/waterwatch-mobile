import 'package:http/http.dart' as client;

Future<String> getCSRFToken() async {
  final uri = Uri.parse('https://waterwatch.tudelft.nl/api/session/');
  final response = await client.get(uri, headers: {
    'Accept': 'application/json',
    'Referer': 'https://waterwatch.tudelft.nl',
  });

  final setCookie = response.headers['set-cookie'];

  if (setCookie == null) {
    throw Exception('Missing Set-Cookie header when fetching CSRF token');
  }

  final csrfPair = setCookie.split(';').firstWhere(
        (segment) => segment.trim().startsWith('csrftoken='),
        orElse: () => throw Exception('No csrftoken segment in: $setCookie'),
      );
  final token = csrfPair.split('=')[1];

  return token;
}
