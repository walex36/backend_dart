import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/modules/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:test/test.dart';

void main() {
  test('jwt service impl ...', () async {
    final dotEnvService = DotEnvService(mocks: {
      'JWT_KEY': 'LKASDJFLASKDJFLKJADKLVLKVLKAS',
    });

    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final jwt = JwtServiceImpl(dotEnvService: dotEnvService);
    final token = jwt.generateToken(
      {
        'id': 1,
        'role': 'user',
        'exp': expiresIn,
      },
      'accessToken',
    );

    print(token);
  });

  test('jwt verify', () async {
    final dotEnvService = DotEnvService(mocks: {
      'JWT_KEY': 'LKASDJFLASKDJFLKJADKLVLKVLKAS',
    });

    final jwt = JwtServiceImpl(dotEnvService: dotEnvService);
    jwt.verifyToken(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NjQ1MDQ1NzcsImlhdCI6MTY2NDUwNDU0NywiYXVkIjoiYWNjZXNzVG9rZW4ifQ.eB_fpyfc0Iv15qm-Kwuyf-9VgMsZVL7Gz-48Yu9vTWw',
      'accessToken',
    );
  });

  test('jwt payload', () async {
    final dotEnvService = DotEnvService(mocks: {
      'JWT_KEY': 'LKASDJFLASKDJFLKJADKLVLKVLKAS',
    });

    final jwt = JwtServiceImpl(dotEnvService: dotEnvService);
    final payload = jwt.getPayload(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NjQ1MDQ1NzcsImlhdCI6MTY2NDUwNDU0NywiYXVkIjoiYWNjZXNzVG9rZW4ifQ.eB_fpyfc0Iv15qm-Kwuyf-9VgMsZVL7Gz-48Yu9vTWw',
    );

    print(payload);
  });
}
