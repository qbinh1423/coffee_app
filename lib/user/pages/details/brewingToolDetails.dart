import 'package:coffee_app/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/drawerUser.dart';
import '../../../theme/theme.dart';

class BrewingToolDetails extends StatefulWidget {
  final String toolName;
  final String imageUrl;
  final String? weight;
  final String? origin;
  final String? cost;
  final String? description;

  const BrewingToolDetails({
    super.key,
    required this.toolName,
    required this.imageUrl,
    this.weight,
    this.origin,
    this.cost,
    this.description,
  });

  @override
  State<BrewingToolDetails> createState() => _BrewingToolDetailsState();
}

class _BrewingToolDetailsState extends State<BrewingToolDetails> {
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
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(widget.imageUrl),
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
                    widget.toolName,
                    style: GoogleFonts.dmSerifDisplay(fontSize: 38),
                  ),
                  ListTile(
                    leading: const Icon(Icons.terrain, size: 26),
                    title: const Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.weight!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wb_cloudy, size: 26),
                    title: const Text(
                      'Origin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.origin!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.mugHot, size: 26),
                    title: const Text(
                      'Cost',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.cost!,
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
                  const SizedBox(height: 10),
                  Text(
                    widget.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
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
