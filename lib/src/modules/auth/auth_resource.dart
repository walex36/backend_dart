import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/modules/auth/guard/auth_guard.dart';
import 'package:backend/src/modules/bcrypt/bcrypt_service.dart';
import 'package:backend/src/modules/jwt/jwt_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        // login
        Route.get('/auth/login', _login),
        // refresh_token
        Route.get('/auth/refresh_token', _refreshToken),
        // check_token
        Route.get('/auth/check_token', _checkToken, middlewares: [AuthGuard()]),
        // update_password
        Route.post('/auth/update_password', _updatePassword),
      ];

  FutureOr<Response> _login(
    Request request,
    Injector injector,
  ) async {
    final extractor = injector.get<RequestExtractor>();
    final bcrypt = injector.get<BCryptService>();
    final jwt = injector.get<JwtService>();
    final credential = extractor.getAuthorizationBasic(request);

    final database = injector.get<RemoteDatabase>();

    final result = await database.query(
      'SELECT id, role, password FROM "User" WHERE email = @email;',
      variables: {
        'email': credential.email,
      },
    );

    if (result.isEmpty) {
      return Response.forbidden(jsonEncode({
        'error': 'Email ou senha invalida',
      }));
    }

    final userMap = result.map((element) => element['User']).first;

    if (!bcrypt.checkHash(credential.password, userMap!['password'])) {
      return Response.forbidden(jsonEncode({
        'error': 'Email ou senha invalida',
      }));
    }

    final claims = userMap..remove('password');
    claims['exp'] = _determineExpiration(Duration(minutes: 10));
    final accessToken = jwt.generateToken(claims, 'accessToken');

    claims['exp'] = _determineExpiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(claims, 'refreshToken');

    return Response.ok(jsonEncode({
      'acess_token': accessToken,
      'refresh_token': refreshToken,
    }));
  }

  FutureOr<Response> _refreshToken() {
    return Response.ok('');
  }

  FutureOr<Response> _checkToken() {
    return Response.ok(jsonEncode({
      'message': 'ok',
    }));
  }

  FutureOr<Response> _updatePassword() {
    return Response.ok('');
  }

  int _determineExpiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }
}
