import 'package:coffee_app/models/store.dart';
import 'package:coffee_app/ui/admin/components/storeCardAdmin.dart';
import 'package:coffee_app/ui/admin/pages/store/editStore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';
import 'store_manager.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StoreManager>().loadStores());

  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: const Text(
          "Store",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.menu,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget> [
          ThemeButton(
            changeThemeMode: (isBright) {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStore(
                    Store(
                      id: '',
                      name: '',
                      location: '',
                      phone: '',
                      description: '',
                      startTime: '',
                      endTime: '',
                      imageUrl: '',
                    ),
                    id: '',
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const AdminDrawer(),
      body: Consumer<StoreManager>(
        builder: (context, storeManager, _) {
          if (storeManager.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: storeManager.items.length,
            itemBuilder: (context, index) {
              return StoreCardAdmin(store: storeManager.items[index]);
            },
          );
        },
      ),
    );
  }
}




    // {
    //   "name": "Blue Bottle Coffee",
    //   "location": "1 Ferry Building #7, San Francisco, CA 94111, United State",
    //   "imageUrl": "assets/images/blue_bottle_coffee.jpg",
    //   "description":
    //       "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
    //   "time": "6:30 - 19:00",
    //   "phone": "+15106613510"
    // },
    // {
    //   "name": "Stumptown Coffee Roasters",
    //   "location": "128 SW 3rd Ave, Portland, OR 97204, United State",
    //   "imageUrl": "assets/images/stumptown_coffee_roasters.png",
    //   "description":
    //       "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
    //   "time": "07:00 - 17:00",
    //   "phone": "+15032956144"
    // },
    // {
    //   "name": "The Coffee Roastery",
    //   "location": "701 San Anselmo Ave, San Anselmo, CA 94960, United State",
    //   "imageUrl": "assets/images/The_Coffee_Roastery.jpeg",
    //   "description":
    //       "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
    //   "time": "06:00 - 17:00",
    //   "phone": "+14157858077"
    // },
    // {
    //   "name": "Morning Brew Coffee & Tea",
    //   "location": "401 Sansome St, San Francisco, CA 94111, United State",
    //   "imageUrl": "assets/images/Morning_Brew_Coffee_&_Tea.jpg",
    //   "description":
    //       "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
    //   "time": "07:00 - 15:00",
    //   "phone": "+14159864206"
    // },