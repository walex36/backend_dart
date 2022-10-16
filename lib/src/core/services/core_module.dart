import 'package:shelf_modular/shelf_modular.dart';

import 'bcrypt/bcrypt_service.dart';
import 'bcrypt/bcrypt_service_impl.dart';
import 'database/postgres/postgres_database.dart';
import 'database/remote_database.dart';
import 'dot_env/dot_env_service.dart';
import 'jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'jwt/jwt_service.dart';
import 'request_extractor/request_extractor.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<DotEnvService>(
          (i) => DotEnvService(),
          export: true,
        ),
        Bind.singleton<RemoteDatabase>(
          (i) => PostgresDatabase(i()),
          export: true,
        ),
        Bind.singleton<BCryptService>(
          (i) => BCryptServiceImpl(),
          export: true,
        ),
        Bind.singleton<JwtService>(
          (i) => JwtServiceImpl(dotEnvService: i()),
          export: true,
        ),
        Bind.singleton(
          (i) => RequestExtractor(),
          export: true,
        ),
      ];
}
