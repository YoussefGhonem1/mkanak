import 'package:flutter/material.dart';
import 'package:rento/src/features/home/screens/home_admin.dart';
import 'package:rento/src/features/home/screens/home_owner.dart';
import 'package:rento/src/features/info_pages/screens/how_it_works_page.dart';
import 'package:rento/src/features/info_pages/screens/privacy_policy_page.dart';
import 'package:rento/src/features/login/screens/login.dart';
import 'package:rento/src/features/on_boarding/presentation/pages/on_boarding_page.dart';
import 'package:rento/src/features/splash/presentation/pages/splash_page.dart';

class Routes {
  static const String splash = '/splash';
  static const String logIn = '/login';
  static const String homeAdmin = '/homeAdmin';
  static const String homeOwner = '/homeOwner';
  static const String onBoarding = '/onboarding';
  static const String privacyPolicy = '/privacyPolicy';
  static const String howItWorks = '/howItWorks';
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
      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case Routes.howItWorks:
        return MaterialPageRoute(builder: (_) => const HowItWorksPage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('404 - Page Not Found')),
              ),
        );
    }
  }
}
