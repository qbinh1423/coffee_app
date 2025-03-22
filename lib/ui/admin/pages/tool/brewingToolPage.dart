import 'package:coffee_app/ui/admin/components/brewingToolCardAdmin.dart';
import 'package:coffee_app/ui/admin/pages/tool/editBrewingTool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/tool.dart';
import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';

class BrewingToolPage extends StatelessWidget {
  BrewingToolPage({super.key});

  final List<Tool> toolsData = [];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: const Text(
          "Brewing Tool",
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
                  builder: (context) => EditBrewingTool(
                    tool: Tool(
                      id: null,
                      name: '',
                      origin: '',
                      imageUrl: '',
                      type: '',
                      material: '',
                      description: '',
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const Admindrawer(),
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 12,
            childAspectRatio: 0.55,
          ),
          itemCount: toolsData.length,
          itemBuilder: (context, index) {
            final tool = toolsData[index];
            return BrewingToolCardAdmin(tool: tool);
          },
        ),
      ),
    );
  }
}
