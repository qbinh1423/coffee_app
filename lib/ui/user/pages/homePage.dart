import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/ui/user/components/drawerUser.dart';
import 'package:coffee_app/ui/user/pages/categoryPage.dart';
import 'package:coffee_app/ui/user/pages/favoritePage.dart';
import 'package:coffee_app/ui/user/pages/storePage.dart';
import '../components/favoriteProvider.dart';
import '../../../theme/theme.dart';
import '../../../theme/themeProvider.dart';

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
  DateTime? lastPressed;
  DateTime? lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    final List<Widget> pages = [
      const CategoryPage(),
      FavoritePage(
        favoriteBeans: favoriteProvider.favoriteBeans,
        favoriteDrinks: favoriteProvider.favoriteDrinks,
        favoriteTools: favoriteProvider.favoriteTools,
      ),
      const StorePage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        const backPressInterval = Duration(seconds: 2);
        if (lastPressed == null ||
            now.difference(lastPressed!) > backPressInterval) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Tap back again to exit the application.',
                style: TextStyle(color: Colors.black),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.yellow.shade200,
            ),
          );
          return false;
        }
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
          ],
        ),
        drawer: const DrawerUser(),
        body: pages[tabIndex],
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
      ),
    );
  }
}
