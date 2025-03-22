import 'package:coffee_app/ui/user/components/drawerUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formChangePasswordKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> obscureCPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    confirmPasswordController.dispose();
    obscurePassword.dispose();
    obscureCPassword.dispose();
    super.dispose();
  }

  Widget _buildChangePasswordForm() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 20.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Theme.of(context).cardColor,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formChangePasswordKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: obscurePassword,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: oldPasswordController,
                                obscureText: value,
                                decoration: InputDecoration(
                                  label: const Text("Old password"),
                                  hintText: "Enter old password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      obscurePassword.value = !value;
                                    },
                                    icon: Icon(
                                      value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: obscureCPassword,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: confirmPasswordController,
                                obscureText: value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'Password must contain at least one uppercase letter';
                                  }
                                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'Password must contain at least one number';
                                  }
                                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                      .hasMatch(value)) {
                                    return 'Password must contain at least one special character';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("New password"),
                                  hintText: "Enter new password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      obscureCPassword.value = !value;
                                    },
                                    icon: Icon(
                                      value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: isLoading,
                            builder: (context, loading, child) {
                              return SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  onPressed: loading
                                      ? null
                                      : () {
                                          isLoading.value = true;
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            isLoading.value = false;
                                          });
                                        },
                                  child: loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          "Save",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Change password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          ThemeButton(
            changeThemeMode: (isBright) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: const DrawerUser(),
      body: Center(
        child: _buildChangePasswordForm(),
      ),
    );
  }
}
