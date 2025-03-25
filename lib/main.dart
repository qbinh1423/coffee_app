import 'package:coffee_app/ui/admin/pages/bean/editCoffeeBean.dart';
import 'package:coffee_app/ui/admin/pages/dashboardPage.dart';
import 'package:coffee_app/ui/admin/pages/store/store_manager.dart';
import 'package:coffee_app/ui/auth/auth_manager.dart';
import 'package:coffee_app/ui/auth/auth_screen.dart';
import 'package:coffee_app/theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';
import 'package:coffee_app/ui/user/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'ui/admin/pages/bean/bean_manager.dart';
import 'ui/admin/pages/drink/drink_manager.dart';
import 'ui/admin/pages/tool/toolManager.dart';
import 'ui/user/components/favoriteProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    debugPrint('Error loading .env: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => AuthManager()),
        ChangeNotifierProvider(create: (context) => BeansManager()),
        ChangeNotifierProvider(create: (context) => ToolManager()),
        ChangeNotifierProvider(create: (context) => DrinkManager()),
        ChangeNotifierProvider(create: (context) => StoreManager()),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeProvider.themeData,
                home: authManager.isAuth
                    ? (authManager.user?.role == 'admin'
                        ? const SafeArea(child: DashboardPage())
                        : const SafeArea(child: HomePage()))
                    : FutureBuilder(
                        future: authManager.tryAutoLogin(),
                        builder: (ctx, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SafeArea(child: SplashScreen())
                              : const SafeArea(child: AuthScreen());
                        }),
                routes: {
                  EditCoffeeBean.routeName: (ctx) =>
                      EditCoffeeBean(null, id: '')
                },
                onGenerateRoute: (settings) {
                  if (settings.name == EditCoffeeBean.routeName) {
                    final args = settings.arguments;
                    if (args is Map<String, dynamic>) {
                      return MaterialPageRoute(
                        builder: (context) {
                          return SafeArea(
                            child: EditCoffeeBean(
                              args['bean'],
                              id: args['id'],
                            ),
                          );
                        },
                      );
                    }
                  }
                  return null;
                },
              );
            },
          );
        },
      ),
    );
  }
}
