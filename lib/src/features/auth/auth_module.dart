import 'package:backend/src/features/auth/datasources/auth_datasource.dart';
import 'package:backend/src/features/auth/datasources/auth_datasource_imp.dart';
import 'package:backend/src/features/auth/repositories/auth_repository.dart';
import 'package:backend/src/features/auth/resources/auth_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthDatasource>(
          (i) => AuthDatasourceImp(database: i()),
        ),
        Bind.singleton(
          (i) => AuthRepository(datasource: i(), bcrypt: i(), jwt: i()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
