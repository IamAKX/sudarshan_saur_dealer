import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saur_dealer/screens/blocked_user/blocked_users_screen.dart';
import 'package:saur_dealer/screens/request/new_request_sreen.dart';

import '../screens/app_intro/app_intro_screen.dart';
import '../screens/customers/warranty_screen.dart';
import '../screens/home_container/home_container.dart';
import '../screens/password_recovery/recover_password_screen.dart';
import '../screens/profile/change_password.dart';
import '../screens/profile/edit_profile.dart';
import '../screens/user_onboarding/agreement_screen.dart';
import '../screens/user_onboarding/login_screen.dart';
import '../screens/user_onboarding/register_screen.dart';

class NavRoute {
  static MaterialPageRoute<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppIntroScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AppIntroScreen());
      case LoginScreen.routePath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RegisterScreen.routePath:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AgreementScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AgreementScreen());
      case RecoverPasswordScreen.routePath:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordScreen());
      case HomeContainer.routePath:
        return MaterialPageRoute(builder: (_) => const HomeContainer());
      case NewRequestScreen.routePath:
        return MaterialPageRoute(builder: (_) => const NewRequestScreen());
      case EditProfile.routePath:
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case ChangePassword.routePath:
        return MaterialPageRoute(builder: (_) => const ChangePassword());
      case WarrentyScreen.routePath:
        return MaterialPageRoute(builder: (_) => const WarrentyScreen());
      case BlockedUserScreen.routePath:
        return MaterialPageRoute(builder: (_) => const BlockedUserScreen());

      default:
        return errorRoute();
    }
  }
}

errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return const Scaffold(
      body: Center(
        child: Text('Undefined route'),
      ),
    );
  });
}
