import 'package:backend/src/core/erros/erros.dart';
import 'package:backend/src/features/user/datasources/user_datasource.dart';
import 'package:backend/src/features/user/models/user.dart';

import '../../../core/services/database/remote_database.dart';

class UserDatasourceImp implements UserDatasource {
  final RemoteDatabase database;

  UserDatasourceImp({required this.database});

  @override
  Future<User> createUser(Map<String, dynamic> user) async {
    try {
      final result = await database.query(
        'INSERT INTO "User"(name, email, password)VALUES (@name, @email, @password) RETURNING id, name, email, role;',
        variables: user,
      );

      if (result.isEmpty) {
        return User.fromMap(user);
      }

      return User.fromMap(result.map((element) => element['User']!).first);
    } catch (e) {
      throw UserException(500, e.toString());
    }
  }

  @override
  Future<void> deletedUser(String id) async {
    try {
      await database.query(
        'DELETE FROM "User" WHERE id = @id;',
        variables: {'id': id},
      );
    } catch (e) {
      throw UserException(500, e.toString());
    }
  }

  @override
  Future<List<User>> getAllUser() async {
    try {
      final result = await database.query(
        'SELECT id, name, email, role FROM "User";',
      );

      if (result.isEmpty) {
        return [];
      }

      return List<User>.from(result.map((e) => User.fromMap(e['User']!)));
    } catch (e) {
      throw UserException(500, e.toString());
    }
  }

  @override
  Future<User> getUserById(String id) async {
    try {
      final result = await database.query(
        'SELECT id, name, email, role FROM "User" WHERE id = @id;',
        variables: {
          'id': id,
        },
      );

      if (result.isEmpty) {
        return User(
          id: 0,
          name: '',
          email: '',
          role: '',
        );
      }

      return User.fromMap(result.map((element) => element['User']!).first);
    } catch (e) {
      throw UserException(500, e.toString());
    }
  }

  @override
  Future<User> updateUser(Map<String, dynamic> user) async {
    try {
      final columns = user.keys
          .where((key) => key != 'id' && key != 'password')
          .map((key) => '$key=@$key')
          .toList();

      final result = await database.query(
        'UPDATE "User" SET ${columns.join(',')}	WHERE id=@id RETURNING id, name, email, role;',
        variables: user,
      );

      return User.fromMap(result.map((element) => element['User']!).first);
    } catch (e) {
      throw UserException(500, e.toString());
    }
  }
}
