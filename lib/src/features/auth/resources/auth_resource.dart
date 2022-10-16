import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/features/auth/guard/auth_guard.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/features/auth/repositories/auth_repository.dart';
import 'package:backend/src/features/auth/erros/erros.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        // login
        Route.get('/login', _login),
        // refresh_token
        Route.get('/refresh_token', _refreshToken, middlewares: [
          AuthGuard(isRefreshToken: true),
        ]),
        // check_token
        Route.get('/check_token', _checkToken, middlewares: [AuthGuard()]),
        // update_password
        Route.put('/update_password', _updatePassword,
            middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _login(
    Request request,
    Injector injector,
  ) async {
    final authRepository = injector.get<AuthRepository>();
    final extractor = injector.get<RequestExtractor>();
    final credential = extractor.getAuthorizationBasic(request);

    try {
      final tokenization = await authRepository.login(credential);

      return Response.ok(tokenization.toJson());
    } on AuthException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _refreshToken(Injector injector, Request request) async {
    final extractor = injector.get<RequestExtractor>();
    final authRepository = injector.get<AuthRepository>();
    final token = extractor.getAuthorizationBearer(request);

    final tokenization = await authRepository.refreshToken(token);

    return Response.ok(tokenization.toJson());
  }

  FutureOr<Response> _checkToken() {
    return Response.ok(jsonEncode({
      'message': 'ok',
    }));
  }

  FutureOr<Response> _updatePassword(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final authRepository = injector.get<AuthRepository>();
    final extractor = injector.get<RequestExtractor>();
    final data = arguments.data;

    final token = extractor.getAuthorizationBearer(request);

    try {
      await authRepository.updatePassword(
        token,
        data['password'],
        data['newPassword'],
      );
      return Response.ok(jsonEncode({
        'message': 'ok',
      }));
    } on AuthException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
