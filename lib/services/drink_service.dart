import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/drink.dart';
import 'pocketbase_client.dart';

class DrinkService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel drinkModel) {
    final drinkImage = drinkModel.getStringValue('drinkImage');

    return pb.files.getUrl(drinkModel, drinkImage).toString();
  }

  Future<Drink?> addDrink(Drink drink, String userId, String toolId) async {
    try {
      final pb = await getPocketbaseInstance();
      print('Bắt đầu addDrink()...');
      print('PocketBase URL: ${pb.baseUrl}');

      if (!pb.authStore.isValid) {
        print('Người dùng chưa đăng nhập hoặc token không hợp lệ.');
        return null;
      }

      final userId = pb.authStore.model?.id;
      print('User ID: $userId, Tool ID: $toolId');
      print(
          'Dữ liệu gửi lên: ${drink.toJson(userId: userId!, toolId: toolId)}');

      List<http.MultipartFile> files = [];
      if (drink.drinkImage != null) {
        final imageBytes = await drink.drinkImage!.readAsBytes();
        final filename = drink.drinkImage!.uri.pathSegments.last;
        print('Tải lên file: $filename');

        files.add(http.MultipartFile.fromBytes(
          'drinkImage',
          imageBytes,
          filename: filename,
        ));
      }

      final record = await pb.collection('drink').create(
        body: {
          ...drink.toJson(userId: userId!, toolId: toolId),
          'userId': userId,
        },
        files: files,
      );

      print('Drink đã lưu thành công: ${record.toJson()}');

      return drink.copyWith(
        id: record.id,
        imageUrl: _getFeaturedImageUrl(pb, record),
      );
    } catch (e) {
      print('Lỗi khi lưu Drink: $e');
      return null;
    }
  }

  Future<Drink?> updateDrink(Drink drink, String userId, String toolId) async {
    try {
      final pb = await getPocketbaseInstance();

      final drinkModel = await pb.collection('drink').update(
            drink.id!,
            body: drink.toJson(userId: userId, toolId: toolId),
            files: drink.drinkImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'drinkImage',
                      await drink.drinkImage!.readAsBytes(),
                      filename: drink.drinkImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );
      return drink.copyWith(
        imageUrl: drink.drinkImage != null
            ? _getFeaturedImageUrl(pb, drinkModel)
            : drink.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteDrink(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('drink').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Drink>> fetchDrink({bool filteredByUser = false}) async {
    final List<Drink> drink = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final drinkModels = await pb
          .collection('drink')
          .getFullList(filter: filteredByUser ? "userId='$userId'" : null);
      for (final drinkModel in drinkModels) {
        drink.add(
          Drink.fromJson(
            drinkModel.toJson()
              ..addAll({'imageUrl': _getFeaturedImageUrl(pb, drinkModel)}),
          ),
        );
      }
      return drink;
    } catch (error) {
      return drink;
    }
  }
}