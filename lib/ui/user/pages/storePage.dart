import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import 'package:coffee_app/ui/screens.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final TextEditingController searchController = TextEditingController();
  List<Store> filteredList = [];
  List<Store> storeList = [];

  void filterStores(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(storeList);
      } else {
        filteredList = storeList
            .where((store) =>
                store.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final storeManager = context.read<StoreManager>();
      storeManager.loadStores().then((_) {
        setState(() {
          storeList = List.from(storeManager.items);
          filteredList = List.from(storeList);
        });
      });
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
                    onChanged: (value) => filterStores(value),
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
              ],
            ),
            const SizedBox(height: 15),
            Consumer<StoreManager>(
              builder: (context, storeManager, child) {
                if (storeManager.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final store = filteredList[index];
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
                                startTime: store.startTime,
                                endTime: store.endTime,
                              ),
                            ),
                          );
                        },
                        child: StoreCard(store: store),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
