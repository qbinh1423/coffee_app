import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';
import '../../../theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';

class UserInforPage extends StatefulWidget {
  const UserInforPage({super.key});

  @override
  State<UserInforPage> createState() => _UserInforPageState();
}

class _UserInforPageState extends State<UserInforPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';

  Future<void> _submitAccount() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      await context.read<AuthManager>().updateUser({
        'name': _name,
        'email': _email,
        'phone': _phone,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Update successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.red.shade200,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final user = context.watch<AuthManager>().user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Your Information",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
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
      drawer: const DrawerUser(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          user?.avatar != null && user!.avatar!.isNotEmpty
                              ? NetworkImage((user.avatar!))
                              : const AssetImage("assets/images/avatar.jpg")
                                  as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Theme.of(context).iconTheme.color,
                              size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: user?.name,
                decoration: _inputDecoration('Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name.' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: user?.email,
                decoration: _inputDecoration('Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter email.' : null,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: user?.phone,
                decoration: _inputDecoration('Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number.';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Phone number must be exactly 10 digits.';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: _submitAccount,
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
