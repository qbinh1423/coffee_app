import 'package:coffee_app/ui/admin/pages/adminInforPage.dart';
import 'package:coffee_app/ui/admin/pages/listPage.dart';
import 'package:coffee_app/ui/auth/auth_manager.dart';
import 'package:coffee_app/ui/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/dashboardPage.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  Future<void> logout(BuildContext context) async {
    try {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error : $e');
    }
  }

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
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => const AdminInforPage(),
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

          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
