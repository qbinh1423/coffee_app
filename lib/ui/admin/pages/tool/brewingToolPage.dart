import 'package:coffee_app/ui/admin/components/brewingToolCardAdmin.dart';
import 'package:coffee_app/ui/admin/pages/tool/editBrewingTool.dart';
import 'package:coffee_app/ui/admin/pages/tool/toolManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/tool.dart';
import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';

class BrewingToolPage extends StatefulWidget {
  const BrewingToolPage({super.key});

  @override
  State<BrewingToolPage> createState() => _BrewingToolPageState();
}

class _BrewingToolPageState extends State<BrewingToolPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ToolManager>().loadTools());
  }

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
                    Tool(
                      id: '',
                      name: '',
                      origin: '',
                      material: '',
                      type: '',
                      description: '',
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
      body: Consumer<ToolManager>(
        builder: (context, toolsManager, _) {
          if (toolsManager.items.isEmpty) {
            return const Center(child: Text("No tools available!"));
          }
          return GridView.builder(
            padding: const EdgeInsets.only(right: 15.0, top: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 0.57,
            ),
            itemCount: toolsManager.items.length,
            itemBuilder: (context, index) {
              return BrewingToolCardAdmin(tool: toolsManager.items[index]);
            },
          );
        },
      ),
    );
  }
}
