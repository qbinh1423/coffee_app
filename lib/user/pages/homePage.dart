import 'package:coffee_app/user/components/drawerUser.dart';
import 'package:coffee_app/user/pages/categoryPage.dart';
import 'package:coffee_app/user/pages/favoritePage.dart';
import 'package:coffee_app/user/pages/storePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/favoriteProvider.dart';
import '../../theme/theme.dart';
import '../../theme/themeProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<NavigationDestination> _navBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      selectedIcon: Icon(Icons.home),
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      label: 'Favorite',
      selectedIcon: Icon(Icons.favorite),
    ),
    NavigationDestination(
      icon: Icon(Icons.store_outlined),
      label: 'Store',
      selectedIcon: Icon(Icons.store),
    ),
  ];

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    final List<Widget> _pages = [
      const CategoryPage(),
      FavoritePage(
        favoriteBeans: favoriteProvider.favoriteBeans,
        favoriteDrinks: favoriteProvider.favoriteDrinks,
        favoriteTools: favoriteProvider.favoriteTools,
      ),
      const StorePage(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const DrawerUser(),
      body: _pages[tabIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.white,
        ),
        child: NavigationBar(
          selectedIndex: tabIndex,
          destinations: _navBarDestinations,
          onDestinationSelected: (index) {
            setState(() {
              tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
