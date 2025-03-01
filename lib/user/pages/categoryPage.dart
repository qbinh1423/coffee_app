import 'package:coffee_app/user/models/beansCard.dart';
import 'package:coffee_app/user/models/brewingToolsCard.dart';
import 'package:coffee_app/user/components/coffeeType.dart';
import 'package:coffee_app/user/models/drinksCard.dart';
import 'package:coffee_app/user/pages/details/beanDetails.dart';
import 'package:coffee_app/user/pages/details/drinkDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'details/brewingToolDetails.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<Map<String, dynamic>> coffeeTypes = [
    {"name": "Beans", "isSelected": true},
    {"name": "Drinks", "isSelected": false},
    {"name": "Brewing Tools", "isSelected": false},
  ];

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

  final List<Map<String, String>> toolsData = [
    {
      "toolName": "Mahlkonig",
      "imageUrl": "assets/images/mahlkonig.jpg",
      "weight": "Machine-brewed coffee",
      "origin": "Italy",
      "cost": "\$180",
      "description":
          "Mahlkonig is the first choice of Baristas around the world. Since 1924 - Mahlkonig coffee grinders have been considered a guarantee of perfect coffee quality. Mahlkonig grinders are capable of operating at high capacity while maintaining a uniform fineness of the powder; thereby retaining the entire essence of the coffee bean aroma. The most obvious result is a unique taste experience in every cup of coffee served to customers. Our products are managed based on a systematic survey of market requirements, to recognize customer preferences and desires. Our Mahlkonig coffee grinders have achieved achievements in both performance and product quality, thanks to the participation and experience of a team of experienced employees in the technical field, in production and even on the assembly line. These are the factors that always put Mahlkonig in the top products on the market.",
    },
    {
      "toolName": "Mahlkonig",
      "imageUrl": "assets/images/mahlkonig.jpg",
      "weight": "Machine-brewed coffee",
      "origin": "Italy",
      "cost": "\$180",
      "description":
          "Mahlkonig is the first choice of Baristas around the world. Since 1924 - Mahlkonig coffee grinders have been considered a guarantee of perfect coffee quality. Mahlkonig grinders are capable of operating at high capacity while maintaining a uniform fineness of the powder; thereby retaining the entire essence of the coffee bean aroma. The most obvious result is a unique taste experience in every cup of coffee served to customers. Our products are managed based on a systematic survey of market requirements, to recognize customer preferences and desires. Our Mahlkonig coffee grinders have achieved achievements in both performance and product quality, thanks to the participation and experience of a team of experienced employees in the technical field, in production and even on the assembly line. These are the factors that always put Mahlkonig in the top products on the market.",
    },
  ];

  String selectedCategory = "Beans";

  void selectCoffeeType(int index) {
    setState(() {
      for (var element in coffeeTypes) {
        element["isSelected"] = false;
      }
      coffeeTypes[index]["isSelected"] = true;
      selectedCategory = coffeeTypes[index]["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Find the best coffee for you",
                style: GoogleFonts.bebasNeue(
                  fontSize: 56,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search something...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600))),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: coffeeTypes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => selectCoffeeType(index),
                      child: CoffeeType(
                        coffeeType: coffeeTypes[index]["name"],
                        isSelected: coffeeTypes[index]["isSelected"],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: (selectedCategory == "Beans"
                          ? beansData
                          : selectedCategory == "Drinks"
                              ? drinksData
                              : toolsData)
                      .map((data) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedCategory == "Beans") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeanDetails(
                                beanName: data['beanName']!,
                                imageUrl: data['imageUrl']!,
                                altitude: data['altitude']!,
                                climate: data['climate']!,
                                caffeine: data['caffeine']!,
                                description: data['description']!,
                              ),
                            ),
                          );
                        } else if (selectedCategory == "Drinks") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrinkDetails(
                                drinkName: data['drinkName']!,
                                imageUrl: data['imageUrl']!,
                                tool: data['tool']!,
                                method: data['method']!,
                                origin: data['origin']!,
                                caffeine: data['caffeine']!,
                                description: data['description']!,
                              ),
                            ),
                          );
                        } else if (selectedCategory == "Brewing Tools") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrewingToolDetails(
                                toolName: data["toolName"]!,
                                imageUrl: data["imageUrl"]!,
                                weight: data["weight"]!,
                                origin: data["origin"]!,
                                cost: data["cost"]!,
                                description: data["description"]!,
                              ),
                            ),
                          );
                        }
                      },
                      child: selectedCategory == "Beans"
                          ? BeansCard(
                              beanName: data["beanName"]!,
                              imageUrl: data["imageUrl"]!,
                              description: data["description"]!,
                            )
                          : selectedCategory == "Drinks"
                              ? DrinksCard(
                                  drinkName: data['drinkName']!,
                                  imageUrl: data['imageUrl']!,
                                  description: data["description"]!,
                                )
                              : BrewingToolsCard(
                                  toolName: data['toolName']!,
                                  imageUrl: data['imageUrl']!,
                                  description: data["description"]!,
                                ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
