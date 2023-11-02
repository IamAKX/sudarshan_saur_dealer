import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saur_dealer/screens/blocked_user/blocked_users_screen.dart';
import 'package:saur_dealer/screens/raise_warranty_request/new_customer.dart';
import 'package:saur_dealer/screens/request/new_request_sreen.dart';
import 'package:saur_dealer/screens/request/warranty_detail.dart';

import '../model/allocated_model.dart';
import '../model/warranty_model.dart';
import '../model/warranty_request_model.dart';
import '../screens/app_intro/app_intro_screen.dart';
import '../screens/customers/dealer_detail.dart';
import '../screens/customers/warranty_screen.dart';
import '../screens/home_container/home_container.dart';
import '../screens/password_recovery/recover_password_screen.dart';
import '../screens/profile/change_password.dart';
import '../screens/profile/edit_profile.dart';
import '../screens/raise_warranty_request/conclusion_screen.dart';
import '../screens/raise_warranty_request/installation_address_screen.dart';
import '../screens/raise_warranty_request/other_information_screen.dart';
import '../screens/raise_warranty_request/owner_address_screen.dart';
import '../screens/raise_warranty_request/photo_upload_screen.dart';
import '../screens/raise_warranty_request/system_details_screen.dart';
import '../screens/user_onboarding/address_screen.dart';
import '../screens/user_onboarding/agreement_screen.dart';
import '../screens/user_onboarding/business_detail.dart';
import '../screens/user_onboarding/change_phone.dart';
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
      case NewCustomerScreen.routePath:
        return MaterialPageRoute(builder: (_) => const NewCustomerScreen());
      case InstallationAddressScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => const InstallationAddressScreen());

      case OwnerAddressScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => OwnerAddressScreen(
            warrantyRequestModel: settings.arguments as WarrantyRequestModel,
          ),
        );
      case SystemDetailScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => SystemDetailScreen(
            warrantyRequestModel: settings.arguments as WarrantyRequestModel,
          ),
        );
      case OtherInformationScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => OtherInformationScreen(
            warrantyRequestModel: settings.arguments as WarrantyRequestModel,
          ),
        );
      case PhotoUploadScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => PhotoUploadScreen(
            warrantyRequestModel: settings.arguments as WarrantyRequestModel,
          ),
        );
      case ConclusionScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => const ConclusionScreen(),
        );

      case EditProfile.routePath:
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case ChangePassword.routePath:
        return MaterialPageRoute(builder: (_) => const ChangePassword());
      case DealerDetail.routePath:
        return MaterialPageRoute(
            builder: (_) => DealerDetail(
                  data: settings.arguments as AllocatedModel,
                ));
      case AddressScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AddressScreen());
      case BusinessDetails.routePath:
        return MaterialPageRoute(builder: (_) => const BusinessDetails());
      case ChangePhoneNumber.routePath:
        return MaterialPageRoute(builder: (_) => const ChangePhoneNumber());

      case WarrentyScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => WarrentyScreen(
                  warrantyRequest: settings.arguments as WarrantyModel,
                ));
      case BlockedUserScreen.routePath:
        return MaterialPageRoute(builder: (_) => const BlockedUserScreen());
      case WarrantyDetailScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => WarrantyDetailScreen(
                  warrantyRequest: settings.arguments as WarrantyModel,
                ));

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
