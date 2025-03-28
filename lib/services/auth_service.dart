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

  Future<User> signup(
      String name, String email, String phone, String password) async {
    final pb = await getPocketbaseInstance();
    try {
      final record = await pb.collection('users').create(body: {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'phone': phone,
        'role': 'user',
      });
      return User.fromJson(record.toJson());
    } catch (error) {
      if (error is ClientException) {
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

  Future<User> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    final pb = await getPocketbaseInstance();

    try {
      final record =
          await pb.collection('users').update(userId, body: updatedData);
      return User.fromJson(record.toJson());
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred while updating information.');
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final pb = await getPocketbaseInstance();

      await pb.collection('users').delete(userId);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.record;

    if (model == null) {
      return null;
    }

    return User.fromJson(model.toJson());
  }

  Future<List<User>> getAllUsers() async {
    final pb = await getPocketbaseInstance();

    try {
      final records =
          await pb.collection('users').getList(filter: "role = 'user'");

      return records.items
          .map((record) => User.fromJson(record.toJson()))
          .toList();
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('Error fetching users');
    }
  }
}
