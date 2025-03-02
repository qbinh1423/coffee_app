import 'package:coffee_app/admin/pages/coffeeBeanPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/themeProvider.dart';
import '../components/adminDrawer.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: const Text(
          "Information",
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
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const Admindrawer(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (e) => CoffeeBeanPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? 'assets/images/coffee-beans-black.png'
                                  : 'assets/images/coffee-beans-white.png',
                              width: 24,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Coffee Beans",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (e) => const Shares(),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.coffee,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Drinks",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (e) => const Shares(),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.coffee_maker,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Brewing Tools",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (e) => const Shares(),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.store,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Stores",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
