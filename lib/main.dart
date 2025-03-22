import 'package:coffee_app/ui/admin/pages/bean/editCoffeeBean.dart';
import 'package:coffee_app/ui/admin/pages/dashboardPage.dart';
import 'package:coffee_app/ui/auth/auth_manager.dart';
import 'package:coffee_app/ui/auth/auth_screen.dart';
import 'package:coffee_app/ui/loginPage.dart';
import 'package:coffee_app/theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';
import 'package:coffee_app/ui/user/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'models/bean.dart';
import 'ui/admin/pages/bean/bean_manager.dart';
import 'ui/user/components/favoriteProvider.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

Future<void> main() async {
  await dotenv.load();
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
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeProvider.themeData,
                home: authManager.isAuth
                  ? const SafeArea(child: DashboardPage()) 
                  : FutureBuilder (
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                      ? const SafeArea(child: SplashScreen()) 
                      : const SafeArea(child: AuthScreen());
                }),
                routes: {
                  EditCoffeeBean.routeName: (ctx) => EditCoffeeBean(null, id: '')
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
