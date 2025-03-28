import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/drink.dart';
import 'pocketbase_client.dart';

class DrinkService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel drinkModel) {
    final drinkImage = drinkModel.getStringValue('drinkImage');

    return pb.files.getUrl(drinkModel, drinkImage).toString();
  }

  Future<Drink?> addDrink(Drink drink) async {
    try {
      final pb = await getPocketbaseInstance();

      if (!pb.authStore.isValid) {
        return null;
      }

      List<http.MultipartFile> files = [];
      if (drink.drinkImage != null) {
        final imageBytes = await drink.drinkImage!.readAsBytes();
        final filename = drink.drinkImage!.uri.pathSegments.last;

        files.add(http.MultipartFile.fromBytes(
          'drinkImage',
          imageBytes,
          filename: filename,
        ));
      }

      final record = await pb.collection('drink').create(
        body: {
          ...drink.toJson(),
          'userId': pb.authStore.model?.id,
        },
        files: files,
      );
      return drink.copyWith(
        id: record.id,
        imageUrl: _getFeaturedImageUrl(pb, record),
      );
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<Drink?> updateDrink(Drink drink) async {
    try {
      final pb = await getPocketbaseInstance();

      final drinkModel = await pb.collection('drink').update(
            drink.id!,
            body: drink.toJson(),
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
      print('Error deleting drink: $error');
      return false;
    }
  }

  Future<List<Drink>> fetchDrink({bool filteredByUser = false}) async {
    final List<Drink> drinks = [];

    try {
      final pb = await getPocketbaseInstance();

      String? filter;

      if (filteredByUser && pb.authStore.isValid) {
        final userId = pb.authStore.record?.id;
        filter = "userId='$userId'";
      }

      final drinkModels =
          await pb.collection('drink').getFullList(filter: filter);
      for (final drinkModel in drinkModels) {
        drinks.add(
          Drink.fromJson(drinkModel.toJson()
            ..addAll({'imageUrl': _getFeaturedImageUrl(pb, drinkModel)})),
        );
      }

      return drinks;
    } catch (error) {
      print('Error fetching drink: $error');
      return [];
    }
  }
}
