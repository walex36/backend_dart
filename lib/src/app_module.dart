import 'package:backend/src/core/services/core_module.dart';
import 'package:backend/src/features/auth/auth_module.dart';
import 'package:backend/src/features/auth/resources/auth_resource.dart';
import 'package:backend/src/features/swagger/swagger_handler.dart';
import 'package:backend/src/features/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('iniciado')),
        Route.get('/doc/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.resource(AuthResource()),
        Route.module('/auth', module: AuthModule()),
      ];
}
