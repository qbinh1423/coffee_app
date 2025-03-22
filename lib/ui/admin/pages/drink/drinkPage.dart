import 'package:coffee_app/ui/admin/components/drinkCardAdmin.dart';
import 'package:coffee_app/ui/admin/pages/drink/editDrink.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';

class DrinkPage extends StatelessWidget {
  DrinkPage({super.key});

  final List<Map<String, String>> drinksData = [
    {
      "drinkName": "Espresso",
      "imageUrl": "assets/images/espresso.jpg",
      "tool": "Machine-brewed coffee",
      "method": "Espresso",
      "origin": "Italy",
      "caffeine": "60-100mg",
      "description":
          "Espresso is a concentrated form of coffee produced by forcing hot water under high pressure through finely ground coffee beans. Originating in Italy, espresso has become one of the most popular coffee-brewing methods worldwide. It is characterized by its small serving size, typically 25–30 ml, and its distinctive layers: a dark body topped with a lighter-colored foam called \"crema\".\n\nEspresso machines use pressure to extract a highly concentrated coffee with a complex flavor profile in a short time, usually 25–30 seconds. The result is a beverage with a higher concentration of suspended and dissolved solids than regular drip coffee, giving espresso its characteristic body and intensity. Despite the stronger taste profile, espresso typically contains fewer milligrams of caffeine than a standard serving of drip-brewed coffee.\n\nEspresso serves as the base for other coffee drinks, including cappuccino, caffè latte, and americano. It can be made with various types of coffee beans and roast levels, allowing for a wide range of flavors and strengths. The quality of an espresso is influenced by factors such as the grind size, water temperature, pressure, and the barista\'s skill in tamping the coffee grounds.\n\nWhile espresso contains more caffeine per unit volume than most coffee beverages, its typical serving size results in less caffeine per serving compared to larger drinks such as drip coffee. The cultural significance of espresso extends beyond its consumption, playing a central role in coffee shop culture and the third-wave coffee movement, which emphasizes artisanal production and high-quality beans.",
      "ingredient": ""
    },
    {
      "drinkName": "Espresso",
      "imageUrl": "assets/images/espresso.jpg",
      "tool": "Machine-brewed coffee",
      "method": "Espresso",
      "origin": "Italy",
      "caffeine": "60-100mg",
      "description":
          "Espresso is a concentrated form of coffee produced by forcing hot water under high pressure through finely ground coffee beans. Originating in Italy, espresso has become one of the most popular coffee-brewing methods worldwide. It is characterized by its small serving size, typically 25–30 ml, and its distinctive layers: a dark body topped with a lighter-colored foam called \"crema\".\n\nEspresso machines use pressure to extract a highly concentrated coffee with a complex flavor profile in a short time, usually 25–30 seconds. The result is a beverage with a higher concentration of suspended and dissolved solids than regular drip coffee, giving espresso its characteristic body and intensity. Despite the stronger taste profile, espresso typically contains fewer milligrams of caffeine than a standard serving of drip-brewed coffee.\n\nEspresso serves as the base for other coffee drinks, including cappuccino, caffè latte, and americano. It can be made with various types of coffee beans and roast levels, allowing for a wide range of flavors and strengths. The quality of an espresso is influenced by factors such as the grind size, water temperature, pressure, and the barista\'s skill in tamping the coffee grounds.\n\nWhile espresso contains more caffeine per unit volume than most coffee beverages, its typical serving size results in less caffeine per serving compared to larger drinks such as drip coffee. The cultural significance of espresso extends beyond its consumption, playing a central role in coffee shop culture and the third-wave coffee movement, which emphasizes artisanal production and high-quality beans.",
      "ingredient": ""
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
                  builder: (context) => const EditDrink(
                    drinkName: '',
                    imageUrl: '',
                    origin: '',
                    tool: '',
                    ingredient: '',
                    caffeine: '',
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
        padding: const EdgeInsets.only(right: 15.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 12,
            childAspectRatio: 0.55,
          ),
          itemCount: drinksData.length,
          itemBuilder: (context, index) {
            final drink = drinksData[index];
            return DrinkCardAdmin(
              drinkName: drink["drinkName"]!,
              origin: drink["origin"]!,
              imageUrl: drink["imageUrl"]!,
              tool: drink["tool"],
              ingredient: drink["ingredient"],
              caffeine: drink["caffeine"],
              description: drink["description"],
            );
          },
        ),
      ),
    );
  }
}
