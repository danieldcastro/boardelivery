import 'package:boardelivery_api/app/core/database/database.dart';
import 'package:boardelivery_api/app/core/exceptions/email_already_registered.dart';
import 'package:boardelivery_api/app/entities/cripty_helper.dart';
import 'package:boardelivery_api/app/entities/user.dart';
import 'package:mysql1/mysql1.dart';

class UserRepository {
  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final isUserRegister = await conn
          .query('select * from usuario where email = ?', [user.email]);

      if (isUserRegister.isEmpty) {
        await conn.query('''
        insert into usuario
        values(?,?,?)
         ''', [
          user.name,
          user.email,
          CriptyHelper.generatedSha256Hash(user.password)
        ]);
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
