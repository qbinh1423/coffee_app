import 'package:coffee_app/services/pocketbase_client.dart';

class DashboardService {
  Future<int> fetchUserCount() async {
    try {
      final pb = await getPocketbaseInstance();

      final result = await pb.collection('users').getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0; 
    }
  }

  Future<int> fetchCoffeeBeanCount() async {
    try {
      final pb = await getPocketbaseInstance();
      final result =
          await pb.collection('bean').getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      print('Error fetching coffee bean count: $e');
      return 0;
    }
  }

  Future<int> fetchCoffeDrinkCount() async {
    try {
      final pb = await getPocketbaseInstance();
      final result =
          await pb.collection('drink').getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      print('Error fetching coffee drink count: $e');
      return 0;
    }
  }

  Future<int> fetchCoffeeToolCount() async {
    try {
      final pb = await getPocketbaseInstance();
      final result =
          await pb.collection('tool').getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      print('Error fetching coffee tool count: $e');
      return 0;
    }
  }

  Future<int> fetchStoreCount() async {
    try {
      final pb = await getPocketbaseInstance();
      final result =
          await pb.collection('store').getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      print('Error fetching store count: $e');
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
