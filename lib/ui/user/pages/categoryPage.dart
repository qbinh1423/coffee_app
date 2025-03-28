import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/bean.dart';
import '../../../models/drink.dart';
import '../../../models/tool.dart';
import 'package:coffee_app/ui/screens.dart';

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
  final TextEditingController searchController = TextEditingController();
  List<Bean> beansFiltered = [];
  List<Drink> drinksFiltered = [];
  List<Tool> toolsFiltered = [];

  void selectCategory(int index) {
    setState(() {
      for (var i = 0; i < coffeeTypes.length; i++) {
        coffeeTypes[i]["isSelected"] = i == index;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final beansManager = context.read<BeansManager>();
      final drinkManager = context.read<DrinkManager>();
      final toolManager = context.read<ToolManager>();

      beansManager.loadBeans().then((_) {
        setState(() {
          beansFiltered = beansManager.items;
        });
      });

      drinkManager.loadDrink().then((_) {
        setState(() {
          drinksFiltered = drinkManager.items;
        });
      });

      toolManager.loadTools().then((_) {
        setState(() {
          toolsFiltered = toolManager.items;
        });
      });
    });
  }

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

  void filterItems(String query) {
    final beans = context.read<BeansManager>().items;
    final drinks = context.read<DrinkManager>().items;
    final tools = context.read<ToolManager>().items;

    setState(() {
      if (query.isEmpty) {
        beansFiltered = beans;
        drinksFiltered = drinks;
        toolsFiltered = tools;
      } else {
        beansFiltered = beans
            .where(
                (bean) => bean.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        drinksFiltered = drinks
            .where((drink) =>
                drink.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        toolsFiltered = tools
            .where(
                (tool) => tool.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
                controller: searchController,
                onChanged: (value) => filterItems(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search something...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: coffeeTypes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => selectCoffeeType(index),
                      child: CoffeeType(
                        coffeeType: coffeeTypes[index]["name"],
                        isSelected:
                            coffeeTypes[index]["name"] == selectedCategory,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  height: 250,
                  child: selectedCategory == "Beans"
                      ? _buildBeansList(context)
                      : selectedCategory == "Drinks"
                          ? _buildDrinksList(context)
                          : _buildToolsList(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeansList(BuildContext context) {
    final beans = context.watch<BeansManager>().items;
    if (beans.isEmpty) {
      return const Center(child: Text("No beans available"));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: beansFiltered.length,
      itemBuilder: (context, index) {
        final bean = beansFiltered[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeanDetails(
                beanName: bean.name,
                imageUrl: bean.imageUrl,
                altitude: bean.altitude,
                climate: bean.climate,
                caffeine: bean.caffeine,
                description: bean.description,
              ),
            ),
          ),
          child: BeansCard(bean: bean),
        );
      },
    );
  }

  Widget _buildDrinksList(BuildContext context) {
    final drinks = context.watch<DrinkManager>().items;
    if (drinks.isEmpty) {
      return const Center(child: Text("No drinks available"));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: drinksFiltered.length,
      itemBuilder: (context, index) {
        final drink = drinksFiltered[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DrinkDetails(
                      drinkName: drink.name,
                      imageUrl: drink.imageUrl,
                      origin: drink.origin,
                      ingredient: drink.ingredients,
                      caffeine: drink.caffeine,
                      description: drink.description,
                      tool: List<String>.from(drink.toolId),
                    )),
          ),
          child: DrinksCard(drink: drink),
        );
      },
    );
  }

  Widget _buildToolsList(BuildContext context) {
    final tools = context.watch<ToolManager>().items;
    if (tools.isEmpty) {
      return const Center(child: Text("No tools available"));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: toolsFiltered.length,
      itemBuilder: (context, index) {
        final tool = toolsFiltered[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrewingToolDetails(
                name: tool.name,
                origin: tool.origin,
                type: tool.type,
                material: tool.material,
                imageUrl: tool.imageUrl,
                description: tool.description,
              ),
            ),
          ),
          child: BrewingToolsCard(tool: tool),
        );
      },
    );
  }
}
