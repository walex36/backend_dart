import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/erros/erros.dart';
import 'package:backend/src/features/auth/guard/auth_guard.dart';
import 'package:backend/src/features/user/models/user.dart';
import 'package:backend/src/features/user/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUser, middlewares: [AuthGuard()]),
        Route.get('/user/:id', _getUserById, middlewares: [AuthGuard()]),
        Route.post('/user', _createUser),
        Route.put('/user', _updateUser, middlewares: [AuthGuard()]),
        Route.delete('/user/:id', _deletedUser, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _getAllUser(Injector injector) async {
    try {
      final userRepository = injector.get<UserRepository>();

      List<User> users = await userRepository.getAllUser();
      List<Map<String, dynamic>> usersMap =
          List.from(users.map((e) => e.toMap()));
      return Response.ok(jsonEncode(usersMap));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _getUserById(
      ModularArguments arguments, Injector injector) async {
    try {
      final id = arguments.params['id'];
      final userRepository = injector.get<UserRepository>();

      User user = await userRepository.getUserById(id);
      return Response.ok(user.toJson());
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _createUser(
      ModularArguments arguments, Injector injector) async {
    try {
      final userRepository = injector.get<UserRepository>();

      User user = await userRepository.createUser(arguments.data);
      return Response.ok(user.toJson());
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _updateUser(
      ModularArguments arguments, Injector injector) async {
    try {
      final userRepository = injector.get<UserRepository>();

      User user = await userRepository.updateUser(arguments.data);
      return Response.ok(user.toJson());
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _deletedUser(
      ModularArguments arguments, Injector injector) async {
    try {
      final id = arguments.params['id'];
      final userRepository = injector.get<UserRepository>();

      await userRepository.deletedUser(id);
      return Response.ok(jsonEncode({'message': 'deleted $id'}));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
