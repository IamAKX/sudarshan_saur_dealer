import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/screens/app_intro/app_intro_screen.dart';
import 'package:saur_dealer/utils/router.dart';
import 'package:saur_dealer/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'model/user_model.dart';
import 'screens/blocked_user/blocked_users_screen.dart';
import 'screens/home_container/home_container.dart';
import 'screens/user_onboarding/login_screen.dart';
import 'services/api_service.dart';
import 'utils/date_time_formatter.dart';
import 'utils/enum.dart';
import 'utils/preference_key.dart';

late SharedPreferences prefs;
UserModel? userModel;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  if (prefs.getInt(SharedpreferenceKey.userId) != null) {
    userModel = await ApiProvider()
        .getDealerById(prefs.getInt(SharedpreferenceKey.userId) ?? -1);

    if (userModel != null) {
      await ApiProvider().updateUser(
          {'lastLogin': DateTimeFormatter.now()}, userModel?.dealerId ?? 0);
    }
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApiProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Sudarshan Saur',
        theme: globalTheme(context),
        debugShowCheckedModeBanner: false,
        home: getHomeScreen(),
        navigatorKey: navigatorKey,
        onGenerateRoute: NavRoute.generatedRoute,
      ),
    );
  }

  getHomeScreen() {
    if (prefs.getBool(SharedpreferenceKey.firstTimeAppOpen) ?? true) {
      prefs.setBool(SharedpreferenceKey.firstTimeAppOpen, false);
      return const AppIntroScreen();
    } else if (userModel == null || userModel?.dealerId == null) {
      return const LoginScreen();
    } else if ((userModel?.status ?? UserStatus.SUSPENDED.name) !=
        UserStatus.ACTIVE.name) {
      return const BlockedUserScreen();
    }
    return const HomeContainer();
  }
}
