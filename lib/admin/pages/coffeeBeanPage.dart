import 'package:coffee_app/admin/informations/editCoffeeBean.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/themeProvider.dart';
import '../components/adminDrawer.dart';
import '../models/beansCardAdmin.dart';

class CoffeeBeanPage extends StatelessWidget {
  CoffeeBeanPage({super.key});

  final List<Map<String, String>> beansData = [
    {
      "beanName": "Arabica",
      "imageUrl": "assets/images/arabica.jpg",
      "altitude": "1000 - 1500 meters",
      "climate": "16-25°C, cool climate, highlands",
      "caffeine": "low, 0.8%-1.5%",
      "description":
          "Arabica coffee has the scientific name Coffea arabica, because this coffee species has small leaves, the tree has some morphological characteristics similar to the tea tree - a popular industrial plant in Vietnam.\n\nArabica coffee has two types: moka coffee and catimor coffee. This is the species with the highest economic value among coffee species. Arabica coffee accounts for 61% of the world\'s coffee production. Arabica coffee is also called Brazilian Milds if it originates from Brazil, Colombian Milds if it originates from Colombia and Other Milds if it originates from other countries. It can be seen that Brazil and Colombia are the two main exporting countries of this type of coffee and their coffee quality is also highly appreciated. Other exporting countries include Ethiopia, Mexico, Guatemala, Honduras, Peru and India.\n\nArabica coffee trees prefer to live in high mountainous areas. Usually grown at an altitude of 1000-1500 m. The tree has a small canopy, dark green leaves, oval shape. Mature coffee trees can be 4-6 m tall, if left to grow wild they can be up to 10 m tall. The fruit is oval, each fruit contains two coffee beans. Arabica coffee can be harvested after about 3 to 4 years of planting. Normally, 25-year-old coffee is considered old and cannot be harvested anymore. In fact, it can continue to live for about 70 years. Arabica coffee trees prefer temperatures from 16-25°C, rainfall of about 1000 mm.\n\nIn the market, Arabica coffee is more highly valued than Robusta coffee (Coffea canephora or Coffea robusta) because it has a delicious flavor and contains less caffeine. A bag of Arabica coffee (60 kg) is usually twice as expensive as a bag of Robusta coffee.",
    },
    {
      "beanName": "Arabica",
      "imageUrl": "assets/images/arabica.jpg",
      "altitude": "1000 - 1500 meters",
      "climate": "16-25°C, cool climate, highlands",
      "caffeine": "low, 0.8%-1.5%",
      "description":
          "Arabica coffee has the scientific name Coffea arabica, because this coffee species has small leaves, the tree has some morphological characteristics similar to the tea tree - a popular industrial plant in Vietnam.\n\nArabica coffee has two types: moka coffee and catimor coffee. This is the species with the highest economic value among coffee species. Arabica coffee accounts for 61% of the world\'s coffee production. Arabica coffee is also called Brazilian Milds if it originates from Brazil, Colombian Milds if it originates from Colombia and Other Milds if it originates from other countries. It can be seen that Brazil and Colombia are the two main exporting countries of this type of coffee and their coffee quality is also highly appreciated. Other exporting countries include Ethiopia, Mexico, Guatemala, Honduras, Peru and India.\n\nArabica coffee trees prefer to live in high mountainous areas. Usually grown at an altitude of 1000-1500 m. The tree has a small canopy, dark green leaves, oval shape. Mature coffee trees can be 4-6 m tall, if left to grow wild they can be up to 10 m tall. The fruit is oval, each fruit contains two coffee beans. Arabica coffee can be harvested after about 3 to 4 years of planting. Normally, 25-year-old coffee is considered old and cannot be harvested anymore. In fact, it can continue to live for about 70 years. Arabica coffee trees prefer temperatures from 16-25°C, rainfall of about 1000 mm.\n\nIn the market, Arabica coffee is more highly valued than Robusta coffee (Coffea canephora or Coffea robusta) because it has a delicious flavor and contains less caffeine. A bag of Arabica coffee (60 kg) is usually twice as expensive as a bag of Robusta coffee.",
    },
    {
      "beanName": "Arabica",
      "imageUrl": "assets/images/arabica.jpg",
      "altitude": "1000 - 1500 meters",
      "climate": "16-25°C, cool climate, highlands",
      "caffeine": "low, 0.8%-1.5%",
      "description":
          "Arabica coffee has the scientific name Coffea arabica, because this coffee species has small leaves, the tree has some morphological characteristics similar to the tea tree - a popular industrial plant in Vietnam.\n\nArabica coffee has two types: moka coffee and catimor coffee. This is the species with the highest economic value among coffee species. Arabica coffee accounts for 61% of the world\'s coffee production. Arabica coffee is also called Brazilian Milds if it originates from Brazil, Colombian Milds if it originates from Colombia and Other Milds if it originates from other countries. It can be seen that Brazil and Colombia are the two main exporting countries of this type of coffee and their coffee quality is also highly appreciated. Other exporting countries include Ethiopia, Mexico, Guatemala, Honduras, Peru and India.\n\nArabica coffee trees prefer to live in high mountainous areas. Usually grown at an altitude of 1000-1500 m. The tree has a small canopy, dark green leaves, oval shape. Mature coffee trees can be 4-6 m tall, if left to grow wild they can be up to 10 m tall. The fruit is oval, each fruit contains two coffee beans. Arabica coffee can be harvested after about 3 to 4 years of planting. Normally, 25-year-old coffee is considered old and cannot be harvested anymore. In fact, it can continue to live for about 70 years. Arabica coffee trees prefer temperatures from 16-25°C, rainfall of about 1000 mm.\n\nIn the market, Arabica coffee is more highly valued than Robusta coffee (Coffea canephora or Coffea robusta) because it has a delicious flavor and contains less caffeine. A bag of Arabica coffee (60 kg) is usually twice as expensive as a bag of Robusta coffee.",
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
          "Coffee Bean",
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
                  builder: (context) => const EditCoffeeBean(
                    beanName: '',
                    imageUrl: '',
                    altitude: '',
                    climate: '',
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
          itemCount: beansData.length,
          itemBuilder: (context, index) {
            final bean = beansData[index];
            return BeansCardAdmin(
              beanName: bean["beanName"]!,
              imageUrl: bean["imageUrl"]!,
              altitude: bean["altitude"],
              climate: bean["climate"],
              caffeine: bean["caffeine"],
              description: bean["description"],
            );
          },
        ),
      ),
    );
  }
}
