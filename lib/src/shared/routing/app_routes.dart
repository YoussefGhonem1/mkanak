
import 'package:flutter/material.dart';
import 'package:rento/src/features/home/screens/home_admin.dart';
import 'package:rento/src/features/home/screens/home_owner.dart';
import 'package:rento/src/features/login/screens/login.dart';
class Routes {
  static const String logIn = '/login';
  static const String homeAdmin = '/homeAdmin';
  static const String homeOwner = '/homeOwner';
}

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.logIn:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.homeAdmin:
        return MaterialPageRoute(builder: (_) => const HomeAdmin());
      case Routes.homeOwner:
        return MaterialPageRoute(builder: (_) => const HomeOwner());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Page Not Found')),
          ),
        );
    }
  }
}
