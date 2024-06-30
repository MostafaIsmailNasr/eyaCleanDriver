import 'package:eya_clean_driver_laundry/AppRouter.dart';
import 'package:eya_clean_driver_laundry/ui/screens/auth/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import 'conustant/di.dart';
import 'notification_service.dart';
FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationService notificationService = NotificationService();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await NotificationService().init();
  await notificationService.initializePlatformNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  setupDependencyInjection();
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'lib/language/',
  );
  runApp(LocalizedApp(
    child: MyApp(appRouter: AppRouter(),),
  ),);
  runApp(
    Phoenix(
      child: //MyApp(appRouter: AppRouter())
      LocalizedApp(child: MyApp(appRouter: AppRouter(),)),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.appRouter});
  final AppRouter appRouter;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: "EyaCleanDriverLaundry",
          theme: ThemeData(
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
              }),
              bottomAppBarColor: Colors.black54,

              scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          home: SplashScreen(),
        );
      },
    );
  }
}


