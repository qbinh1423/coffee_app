import 'package:coffee_app/models/bean.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';


class CoffeeBeanPage extends StatefulWidget {
  const CoffeeBeanPage({super.key});

  @override
  State<CoffeeBeanPage> createState() => _CoffeeBeanPageState();
}

class _CoffeeBeanPageState extends State<CoffeeBeanPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BeansManager>().loadBeans());
  }

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
                    builder: (context) => EditCoffeeBean(
                          Bean(
                            id: '',
                            name: '',
                            altitude: '',
                            climate: '',
                            caffeine: '',
                            description: '',
                            origin: '',
                            imageUrl: '',
                          ),
                          id: '',
                        )),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const AdminDrawer(),
      body: Consumer<BeansManager>(
        builder: (context, beansManager, _) {
          if (beansManager.items.isEmpty) {
            return const Center(child: Text("No beans available!"));
          }
          return GridView.builder(
            padding: const EdgeInsets.only(right: 15.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 0.56,
            ),
            itemCount: beansManager.items.length,
            itemBuilder: (context, index) {
              return BeansCardAdmin(bean: beansManager.items[index]);
            },
          );
        },
      ),
    );
  }
}
