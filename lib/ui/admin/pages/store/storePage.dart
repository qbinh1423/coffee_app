import 'package:coffee_app/ui/admin/components/storeCardAdmin.dart';
import 'package:coffee_app/ui/admin/pages/store/editStore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';

class StorePage extends StatelessWidget {
  StorePage({super.key});

  final List<Map<String, String>> storeData = [
    {
      "name": "Blue Bottle Coffee",
      "location": "1 Ferry Building #7, San Francisco, CA 94111, United State",
      "imageUrl": "assets/images/blue_bottle_coffee.jpg",
      "description":
          "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
      "time": "6:30 - 19:00",
      "phone": "+15106613510"
    },
    {
      "name": "Stumptown Coffee Roasters",
      "location": "128 SW 3rd Ave, Portland, OR 97204, United State",
      "imageUrl": "assets/images/stumptown_coffee_roasters.png",
      "description":
          "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
      "time": "07:00 - 17:00",
      "phone": "+15032956144"
    },
    {
      "name": "The Coffee Roastery",
      "location": "701 San Anselmo Ave, San Anselmo, CA 94960, United State",
      "imageUrl": "assets/images/The_Coffee_Roastery.jpeg",
      "description":
          "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
      "time": "06:00 - 17:00",
      "phone": "+14157858077"
    },
    {
      "name": "Morning Brew Coffee & Tea",
      "location": "401 Sansome St, San Francisco, CA 94111, United State",
      "imageUrl": "assets/images/Morning_Brew_Coffee_&_Tea.jpg",
      "description":
          "Trendy cafe chain serving pastries, premium coffees, beans and coffee making supplies.",
      "time": "07:00 - 15:00",
      "phone": "+14159864206"
    },
  ];

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
        actions: [
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
                  builder: (context) => const EditStore(
                    storeName: '',
                    storeLocation: '',
                    imageUrl: '',
                    phone: '',
                    time: '',
                    description: '',
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const Admindrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: ListView.builder(
          itemCount: storeData.length,
          itemBuilder: (context, index) {
            final store = storeData[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: StoreCardAdmin(
                storeName: store["name"]!,
                storeLocation: store["location"]!,
                imageUrl: store["imageUrl"]!,
                phone: store["phone"],
                time: store["time"],
                description: store["description"],
              ),
            );
          },
        ),
      ),
    );
  }
}
