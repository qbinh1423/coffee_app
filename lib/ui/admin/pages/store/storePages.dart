import 'package:coffee_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';


class StorePages extends StatefulWidget {
  const StorePages({super.key});

  @override
  State<StorePages> createState() => _StorePagesState();
}

class _StorePagesState extends State<StorePages> {
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
        actions: <Widget>[
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
            return const Center(child: Text("No stores available!"));
          }
          return GridView.builder(
            padding: const EdgeInsets.only(right: 15.0, top: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 0.56,
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
