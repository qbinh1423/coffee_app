import 'package:coffee_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';
import '../../../theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';


class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _userList;

  @override
  void initState() {
    super.initState();
    _userList = context.read<AuthManager>().fetchAllUsers();
    _loadUsers();
  }

  final searchController = TextEditingController();
  List<Map<String, String>> filteredList = [];
  List<Map<String, String>> usernameList = [];

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(usernameList);
      } else {
        filteredList = usernameList
            .where((user) =>
                user['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _loadUsers() async {
    final authManager = context.read<AuthManager>();
    final users = await authManager.fetchAllUsers();

    setState(() {
      usernameList = users.map((user) {
        return {
          'id': user.id,
          'name': user.name ?? '',
        };
      }).toList();
      filteredList = List.from(usernameList);
    });
  }

  Future<void> _deleteUser(String userId, int index) async {
    final authManager = context.read<AuthManager>();

    bool isDeleted = await authManager.deleteUser(userId);

    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'User deleted successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
      _loadUsers();
      setState(() {
        filteredList.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to delete user!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.red.shade200,
        ),
      );
    }
  }

  Future<bool> _showDeleteConfirm(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this user?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget listUser() {
    return FutureBuilder<List<User>>(
      future: _userList,
      builder: (context, snapshot) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                onChanged: (query) => filterUsers(query),
                decoration: InputDecoration(
                  hintText: "Find user",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final user = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user['name']!),
                      subtitle: Text('ID: ${user['id']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool confirmDelete =
                              await _showDeleteConfirm(context);
                          if (confirmDelete) {
                            print("ID muốn xóa: ${user['id']}");
                            await _deleteUser(user['id']!, index);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          "List User",
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
        ],
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: listUser(),
      ),
    );
  }
}
