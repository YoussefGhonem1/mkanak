import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rento/firebase_options.dart';
import 'package:rento/src/features/notifications/repository/firebase_notification.dart';
import 'package:rento/src/shared/routing/app_routes.dart';
import 'package:rento/src/shared/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  sharedPref = await SharedPreferences.getInstance();
  await FirebaseNotifications().initNotification();
  await FirebaseNotifications().initializeLocalNotifications();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
       onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: appTheme,
       initialRoute: sharedPref.getString("id") == null
      ? '/splash'
      : '/homeOwner'
     
    );
  }
}
