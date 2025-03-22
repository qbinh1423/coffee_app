import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../models/user.dart';
import 'pocketbase_client.dart';

class AuthService {
  void Function(User? user)? onAuthChange;

  AuthService({this.onAuthChange}) {
    if (onAuthChange != null) {
      getPocketbaseInstance().then((pb) {
        pb.authStore.onChange.listen((event) {
          onAuthChange!(event.record == null
              ? null
              : User.fromJson(event.record!.toJson()));
        });
      });
    }
  }

  Future<User> signup(String name, String email, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      final record = await pb.collection('users').create(body: {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': password,
      });
      print("Đăng ký thành công");
      return User.fromJson(record.toJson());
    } catch (error) {
      if (error is ClientException) {
        debugPrint('PocketBase Error: ${error.response}');
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();
    try {
      final authRecord =
          await pb.collection('users').authWithPassword(email, password);
      
      return User.fromJson(authRecord.record.toJson());
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.record;

    if (model == null) {
      return null;
    }

    return User.fromJson(model.toJson());
  }
}
