import 'package:coffee_app/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/drawerUser.dart';
import '../../../theme/theme.dart';

class DrinkDetails extends StatefulWidget {
  final String drinkName;
  final String imageUrl;
  final String tool;
  final String method;
  final String origin;
  final String caffeine;
  final String? description;
  final String? ingredient;
  const DrinkDetails({
    super.key,
    required this.drinkName,
    required this.imageUrl,
    required this.tool,
    required this.method,
    required this.origin,
    required this.caffeine,
    this.description,
    this.ingredient,
  });

  @override
  State<DrinkDetails> createState() => _DrinkDetailsState();
}

class _DrinkDetailsState extends State<DrinkDetails> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                Image.asset(widget.imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.drinkName,
                    style: GoogleFonts.dmSerifDisplay(fontSize: 38),
                  ),
                  ListTile(
                    leading: const Icon(Icons.coffee_maker, size: 26),
                    title: const Text(
                      'Tool',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.tool,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.coffee_maker, size: 26),
                    title: const Text(
                      'Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.method,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on, size: 26),
                    title: const Text(
                      'Origin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.origin,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.mugHot, size: 26),
                    title: const Text(
                      'Caffein',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.caffeine,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isFavorited = !_isFavorited;
                            });
                          },
                          icon: Icon(
                            _isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          iconSize: 26.0,
                          color: Colors.red[400],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          iconSize: 26.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Tips:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
