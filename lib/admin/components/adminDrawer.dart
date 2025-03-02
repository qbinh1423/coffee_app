import 'package:coffee_app/admin/pages/listPage.dart';
import 'package:flutter/material.dart';
import '../pages/dashboardPage.dart';

class Admindrawer extends StatelessWidget {
  const Admindrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          AppBar(
            title: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/images/logoapp.png'
                    : 'assets/images/logoappwhite.png',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => const DashboardPage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Information',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) => const ListPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
