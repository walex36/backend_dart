import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/modules/jwt/jwt_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;

  AuthGuard({this.roles = const []});

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extractor = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(jsonEncode({
          'error': 'not authorization header',
        }));
      }

      final token = extractor.getAuthorizationBearer(request);
      try {
        jwt.verifyToken(token, 'accessToken');
        final payload = jwt.getPayload(token);
        final role = payload['role'] ?? 'user';

        if (roles.isEmpty || roles.contains(role)) {
          return handler(request);
        }

        return Response.forbidden(jsonEncode({
          'error': 'role ($role) not allowed',
        }));
      } catch (e) {
        return Response.forbidden(jsonEncode({
          'error': e.toString(),
        }));
      }
    };
  }
}
