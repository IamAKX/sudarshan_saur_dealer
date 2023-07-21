import 'package:flutter/material.dart';
import 'package:saur_dealer/screens/app_intro/app_intro_screen.dart';
import 'package:saur_dealer/utils/router.dart';
import 'package:saur_dealer/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudarshan Saur',
      theme: globalTheme(context),
      debugShowCheckedModeBanner: false,
      home: const AppIntroScreen(),
      navigatorKey: navigatorKey,
      onGenerateRoute: NavRoute.generatedRoute,
    );
  }
}
