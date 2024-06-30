import 'package:eya_clean_driver_laundry/ui/screens/auth/changeLanguage/change_language_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/auth/login/Login_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/auth/splash/splash_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/auth/verifyCode/Verfiy_code_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/home/drower_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/more/aboutApp/about_app_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/more/faqs/faqs.dart';
import 'package:eya_clean_driver_laundry/ui/screens/more/profile/profile_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/more/termsAndConditions/terms_and_condition_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/more/wallet/wallet_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/notification/notificatio_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/orderDetails/order_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case'/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case'/change_language_screen':
        return MaterialPageRoute(builder: (_) => ChangeLanguageScreen());
      case'/Login_screen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case'/Verfiy_code_screen':
        final code=settings.arguments as int;
        //final phone=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => VerfiyCodeScreen(code: code,));
      case'/drower_screen':
        final from=settings.arguments as int;
        return MaterialPageRoute(builder: (_) => DrowerScreen(index: from,));
      // case'/profile_screen':
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      case'/wallet_screen':
        return MaterialPageRoute(builder: (_) => WalletScreen());
      case'/about_app_screen':
        return MaterialPageRoute(builder: (_) => AboutAppScreen());
      case'/faqs':
        return MaterialPageRoute(builder: (_) => FaqsScreen());
      case'/terms_and_condition_screen':
        return MaterialPageRoute(builder: (_) => TermsAndConditionScreen());
      case'/profile_screen':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case'/order_details_screen':
        final from=settings.arguments as int;
        final from2=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderDetailsScreen(id:from,from: from2,));
      case'/notificatio_screen':
        return MaterialPageRoute(builder: (_) => NotificationScreen());
    }
  }
}