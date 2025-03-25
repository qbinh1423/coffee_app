import 'package:coffee_app/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';
import '../../../theme/themeProvider.dart';
import '../components/adminDrawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _dashboardService = DashboardService();

  int userCount = 0;
  int coffeeBeanCount = 0;
  int drinkCount = 0;
  int toolCount = 0;
  int storeCount = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final users = await _dashboardService.fetchItemCount('users');
    final coffeeBeans = await _dashboardService.fetchItemCount('bean');
    final drinks = await _dashboardService.fetchItemCount('drink');
    final tools = await _dashboardService.fetchItemCount('tool');
    final stores = await _dashboardService.fetchItemCount('store');

    setState(() {
      userCount = users;
      coffeeBeanCount = coffeeBeans;
      drinkCount = drinks;
      toolCount = tools;
      storeCount = stores;
    });
  }


  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: const Text(
          "Dashboard",
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
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            DashboardCard(
              icon: const Icon(Icons.people, size: 50),
              label: "Users",
              count: userCount,
            ),
            DashboardCard(
              icon: Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/images/coffee-beans-black.png'
                    : 'assets/images/coffee-beans-white.png',
                width: 50,
                height: 50,
              ),
              label: "Coffee Beans",
              count: coffeeBeanCount,
            ),
            DashboardCard(
              icon: const Icon(Icons.local_cafe, size: 50),
              label: "Drinks",
              count: drinkCount,
            ),
            DashboardCard(
              icon: const Icon(Icons.coffee_maker, size: 50),
              label: "Brewing Tools",
              count: toolCount,
            ),
            DashboardCard(
              icon: const Icon(Icons.store, size: 50),
              label: "Stores",
              count: storeCount,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final int count;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
