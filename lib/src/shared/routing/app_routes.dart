
import 'package:flutter/material.dart';
import 'package:rento/src/features/home/screens/home_admin.dart';
import 'package:rento/src/features/home/screens/home_owner.dart';
import 'package:rento/src/features/login/screens/login.dart';
import 'package:rento/src/features/on_boarding/presentation/pages/on_boarding_page.dart';
import 'package:rento/src/features/splash/presentation/pages/splash_page.dart';
class Routes {
  static const String splash = '/splash';
  static const String logIn = '/login';
  static const String homeAdmin = '/homeAdmin';
  static const String homeOwner = '/homeOwner';
  static const String onBoarding = '/onboarding';
}

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
       case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.logIn:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
          case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingPage());
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
