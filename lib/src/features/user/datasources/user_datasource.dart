import 'package:backend/src/features/user/models/user.dart';

abstract class UserDatasource {
  Future<List<User>> getAllUser();

  Future<User> getUserById(String id);

  Future<User> createUser(Map<String, dynamic> user);

  Future<User> updateUser(Map<String, dynamic> user);

  Future<void> deletedUser(String id);
}
