import 'package:backend/src/core/services/database/postgres/postgres_database.dart';
import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/modules/bcrypt/bcrypt_service.dart';
import 'package:backend/src/modules/bcrypt/bcrypt_service_impl.dart';
import 'package:backend/src/modules/swagger/swagger_handler.dart';
import 'package:backend/src/modules/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService()),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i())),
        Bind.singleton<BCryptService>((i) => BCryptServiceImpl()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('iniciado')),
        Route.get('/doc/**', swaggerHandler),
        Route.resource(UserResource()),
      ];
}
