import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/features/user/datasources/user_datasource.dart';
import 'package:backend/src/features/user/models/user.dart';

class UserRepository {
  final BCryptService bcrypt;
  final UserDatasource datasource;

  UserRepository({
    required this.bcrypt,
    required this.datasource,
  });

  Future<List<User>> getAllUser() async {
    return await datasource.getAllUser();
  }

  Future<User> getUserById(String id) async {
    return await datasource.getUserById(id);
  }

  Future<User> createUser(Map<String, dynamic> user) async {
    final userParams = user.cast<String, dynamic>();

    userParams['password'] = bcrypt.gerenateHash(userParams['password']);

    userParams.remove('id');

    return await datasource.createUser(userParams);
  }

  Future<User> updateUser(Map<String, dynamic> user) async {
    final userParams = user.cast<String, dynamic>();

    return await datasource.updateUser(userParams);
  }

  Future<void> deletedUser(String id) async {
    await datasource.deletedUser(id);
  }
}
