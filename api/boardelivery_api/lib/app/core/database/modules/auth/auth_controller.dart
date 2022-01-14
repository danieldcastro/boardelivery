import 'dart:async';
import 'dart:convert';
import 'package:boardelivery_api/app/core/exceptions/email_already_registered.dart';
import 'package:boardelivery_api/app/entities/user.dart';
import 'package:boardelivery_api/app/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRq = User.fromJson(await request.readAsString());
      await _userRepository.save(userRq);
      return Response(
        200,
        headers: {
          'content-type': 'application/json',
        },
      );
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(
        400,
        body: jsonEncode({'error': 'E-mail já utilizado por outro usuário'}),
        headers: {
          'content-type': 'application/json',
        },
      );
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
