import 'package:coffee_app/models/drink.dart';
import 'package:coffee_app/ui/admin/components/drinkCardAdmin.dart';
import 'package:coffee_app/ui/admin/pages/drink/drink_manager.dart';
import 'package:coffee_app/ui/admin/pages/drink/editDrink.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  // final List<Map<String, String>> drinksData = [
   
  // ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: const Text(
          "Drink",
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
                  builder: (context) => EditDrink(
                    Drink(
                      id: '',
                      name: '',
                      ingredients: [],
                      caffeine: '',
                      description: '',
                      origin: '',
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
      body: Consumer<DrinkManager>(
        builder: (context, drinkManager, _) {
          if (drinkManager.items.isEmpty) {
            return const Center(child: Text("No beans available!"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: drinkManager.items.length,
            itemBuilder: (context, index) {
              return DrinkCardAdmin(drink: drinkManager.items[index]);
            },
          );
        },
      ),
    );
  }
}
