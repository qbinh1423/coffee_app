import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import '../models/bean.dart';

import 'pocketbase_client.dart';

class BeansService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel beanModel) {
    final beanImage = beanModel.getStringValue('beanImage');

    return pb.files.getUrl(beanModel, beanImage).toString();
  }

  Future<Bean?> addBean(Bean bean) async {
    try {
      final pb = await getPocketbaseInstance();

      if (!pb.authStore.isValid) {
        return null;
      }
      List<http.MultipartFile> files = [];
      if (bean.beanImage != null) {
        final imageBytes = await bean.beanImage!.readAsBytes();
        final filename = bean.beanImage!.uri.pathSegments.last;

        files.add(http.MultipartFile.fromBytes(
          'beanImage',
          imageBytes,
          filename: filename,
        ));
      }

      final record = await pb.collection('bean').create(
        body: {
          ...bean.toJson(),
          'userId': pb.authStore.model?.id,
        },
        files: files,
      );
      return bean.copyWith(
        id: record.id,
        imageUrl: _getFeaturedImageUrl(pb, record),
      );
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<Bean?> updateBean(Bean bean) async {
    try {
      final pb = await getPocketbaseInstance();
      final beanModel = await pb.collection('bean').update(
            bean.id!,
            body: bean.toJson(),
            files: bean.beanImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'beanImage',
                      await bean.beanImage!.readAsBytes(),
                      filename: bean.beanImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );
      return bean.copyWith(
        imageUrl: bean.beanImage != null
            ? _getFeaturedImageUrl(pb, beanModel)
            : bean.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteBean(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('bean').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Bean>> fetchBeans({bool filteredByUser = false}) async {
    final List<Bean> beans = [];
    try {
      final pb = await getPocketbaseInstance();

      String? filter;

      if (filteredByUser && pb.authStore.isValid) {
        final userId = pb.authStore.record?.id;
        filter = "userId='$userId'";
      }

      final beanModels =
          await pb.collection('bean').getFullList(filter: filter);
      for (final beanModel in beanModels) {
        beans.add(
          Bean.fromJson(beanModel.toJson()
            ..addAll({'imageUrl': _getFeaturedImageUrl(pb, beanModel)})),
        );
      }
      return beans;
    } catch (error) {
      print('Error fetching beans: $error');
      return [];
    }
  }
}
