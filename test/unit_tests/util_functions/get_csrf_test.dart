import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as client;
import 'package:http/testing.dart';
import 'package:waterwatch/util/util_functions/get_csrf_token.dart';

void main() {
  test('getCSRFToken sends correct headers and parses the token', () async {
    // 1) Arrange: setup a mock HTTP client
    final mockClient = MockClient((request) async {
      // verify the request
      expect(request.method, equals('GET'));
      expect(
        request.url.toString(),
        equals('https://waterwatch.tudelft.nl/api/session/'),
      );
      expect(request.headers['Accept'], equals('application/json'));
      expect(
        request.headers['Referer'],
        equals('https://waterwatch.tudelft.nl'),
      );

      // respond with a Set-Cookie header
      return client.Response(
        '', // body unused
        200,
        headers: {
          'set-cookie':
              'csrftoken=TEST_TOKEN_123; Path=/; HttpOnly; SameSite=Lax',
        },
      );
    });

    // 2) Act: call getCSRFToken with the mock client
    final token = await getCSRFToken(httpClient: mockClient);

    // 3) Assert: it extracted the right token
    expect(token, equals('TEST_TOKEN_123'));
  });

  test('getCSRFToken throws if no set-cookie header', () async {
    final mockClient = MockClient((_) async => client.Response('', 200));
    expect(
      () => getCSRFToken(httpClient: mockClient),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Missing Set-Cookie'),
      )),
    );
  });
}
