import 'package:coffee_app/services/pocketbase_client.dart';

class DashboardService {
  Future<int> fetchUserCount() async {
    try {
      final pb = await getPocketbaseInstance();
      final result = await pb
          .collection('users')
          .getList(page: 1, perPage: 1, filter: "role = 'user'");
      return result.totalItems;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0;
    }
  }

  Future<int> fetchItemCount(String collectionName) async {
    try {
      final pb = await getPocketbaseInstance();
      final result =
          await pb.collection(collectionName).getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      print('Error fetching $collectionName count: $e');
      return 0;
    }
  }
}
