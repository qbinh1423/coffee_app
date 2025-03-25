import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_app/ui/user/components/storeCard.dart';
import 'package:provider/provider.dart';
import '../../admin/pages/store/store_manager.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<StoreManager>(context, listen: false).fetchStores());
  }

  void _setFilter(FilterOptions selectedValue) {
    setState(() {
      currentFilter = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    var storeManager = Provider.of<StoreManager>(context);
    var stores = storeManager.items;
    print("Stores: ${storeManager.items}");

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
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreDetails(
                            storeName: store.name,
                            storeLocation: store.location,
                            imageUrl: store.imageUrl,
                            description: store.description,
                            phone: store.phone,
                          ),
                        ),
                      );
                    },
                    child: StoreCard(store: store),
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
