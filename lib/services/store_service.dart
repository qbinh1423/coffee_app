import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/store.dart';
import 'pocketbase_client.dart';

class StoreService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel storeModel) {
    final storeImage = storeModel.getStringValue('storeImage');

    return pb.files.getUrl(storeModel, storeImage).toString();
  }

  Future<Store?> addStore(Store store) async {
    try {
      final pb = await getPocketbaseInstance();

      if (!pb.authStore.isValid) {
        return null;
      }

      List<http.MultipartFile> files = [];
      if (store.storeImage != null) {
        final imageBytes = await store.storeImage!.readAsBytes();
        final filename = store.storeImage!.uri.pathSegments.last;

        files.add(http.MultipartFile.fromBytes(
          'storeImage',
          imageBytes,
          filename: filename,
        ));
      }

      final record = await pb.collection('store').create(
        body: {
          ...store.toJson(),
          'userId': pb.authStore.model?.id,
        },
        files: files,
      );
      return store.copyWith(
        id: record.id,
        imageUrl: _getFeaturedImageUrl(pb, record),
      );
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<Store?> updateStore(Store store) async {
    try {
      final pb = await getPocketbaseInstance();

      final storeModel = await pb.collection('store').update(
            store.id!,
            body: store.toJson(),
            files: store.storeImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'storeImage',
                      await store.storeImage!.readAsBytes(),
                      filename: store.storeImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );
      return store.copyWith(
        imageUrl: store.storeImage != null
            ? _getFeaturedImageUrl(pb, storeModel)
            : store.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteStore(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('store').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Store>> fetchStore({bool filteredByUser = false}) async {
    final List<Store> stores = [];

    try {
      final pb = await getPocketbaseInstance();
      String? filter;

      if (filteredByUser && pb.authStore.isValid) {
        final userId = pb.authStore.record?.id;
        filter = "userId='$userId' || userId='' || userId='admin'";
      }
      final storeModels =
          await pb.collection('store').getFullList(filter: filter);

      for (final storeModel in storeModels) {
        final imageUrl = _getFeaturedImageUrl(pb, storeModel);
        stores.add(
          Store.fromJson(
            storeModel.toJson()..addAll({'imageUrl': imageUrl}),
          ),
        );
      }

      return stores;
    } catch (error) {
      print('Error fetching store: $error');
      return [];
    }
  }
}
