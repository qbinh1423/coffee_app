import 'package:coffee_app/ui/auth/auth_manager.dart';
import 'package:coffee_app/ui/loginPage.dart';
import 'package:coffee_app/ui/user/pages/homePage.dart';
import 'package:coffee_app/ui/user/pages/userInforPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/settingPage.dart';


class InforAccount extends StatefulWidget {
  const InforAccount({super.key});

  @override
  State<InforAccount> createState() => _InforAccountState();
}

class _InforAccountState extends State<InforAccount> {
  String userName = 'Jennifer';
  String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipOval(
          child: photoUrl != null
              ? Image.network(photoUrl!, fit: BoxFit.cover)
              : Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover),
        ),
      ),
      accountName: Text(
        userName,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
        ),
      ),
      accountEmail: null,
    );
  }
}

class DrawerUser extends StatelessWidget {
  const DrawerUser({super.key});

  Future<void> logout(BuildContext context) async {
    try {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
        children: <Widget> [
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
              Icons.settings,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) => const SettingPage(),
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
              Navigator.of(context)..pop()..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
