import 'package:coffee_app/ui/auth/auth_manager.dart';
import 'package:coffee_app/ui/auth/auth_screen.dart';
import 'package:coffee_app/ui/user/pages/homePage.dart';
import 'package:coffee_app/ui/user/pages/shareApp.dart';
import 'package:coffee_app/ui/user/pages/userInforPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InforAccount extends StatefulWidget {
  const InforAccount({super.key});

  @override
  State<InforAccount> createState() => _InforAccountState();
}

class _InforAccountState extends State<InforAccount> {
  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context);
    final user = authManager.user;

    String userName = user?.name ?? 'Guest';

    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover),
        ),
      ),
      accountName: Text(
        userName,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
        ),
      ),
      accountEmail: Text(
        user?.email ?? '',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 14,
        ),
      ),
    );
  }
}

class DrawerUser extends StatelessWidget {
  const DrawerUser({super.key});

  Future<void> logout(BuildContext context) async {
    try {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Logout successfully.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade300,
        ),
      );
    } catch (e) {
      print('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const InforAccount(),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
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
                  builder: (e) => const UserInforPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
            ),
            title: const Text(
              'Share',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) => const ShareApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
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
