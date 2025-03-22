import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_app/ui/user/components/storeCard.dart';
import 'details/storeDetails.dart';

enum FilterOptions { favorites, all }

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  FilterOptions currentFilter = FilterOptions.all;
  final TextEditingController searchController = TextEditingController();

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

  void _setFilter(FilterOptions selectedValue) {
    setState(() {
      currentFilter = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore where to buy coffee",
              style: GoogleFonts.bebasNeue(fontSize: 56),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search place',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<FilterOptions>(
                  onSelected: _setFilter,
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: FilterOptions.favorites,
                      child: Text('Only Favorites'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.all,
                      child: Text('Show All'),
                    ),
                  ],
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: storeData.length,
                itemBuilder: (context, index) {
                  final store = storeData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreDetails(
                            storeName: store["name"]!,
                            storeLocation: store["location"]!,
                            imageUrl: store["imageUrl"]!,
                            description: store["description"]!,
                            phone: store["phone"]!,
                            time: store["time"]!,
                          ),
                        ),
                      );
                    },
                    child: StoreCard(
                      storeName: store["name"]!,
                      storeLocation: store["location"]!,
                      imageUrl: store["imageUrl"]!,
                      description: "",
                      phone: "",
                      time: "",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
