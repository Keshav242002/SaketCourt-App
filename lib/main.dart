import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saketcourt/firebase_options.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/screens/circulars.dart';
import 'package:saketcourt/screens/event.dart';
import 'package:saketcourt/screens/forget_password.dart';
import 'package:saketcourt/screens/impLinks.dart';
import 'package:saketcourt/screens/login_screen.dart';
import 'package:saketcourt/screens/profile.dart';
import 'package:saketcourt/screens/searchMember.dart';
import 'package:saketcourt/screens/splash_screen.dart';
import 'package:saketcourt/screens/subscriptions.dart';
import 'package:saketcourt/utils/constants.dart';
import 'package:saketcourt/utils/push_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    // Initialize notification services
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        glbToken = value;
        print('Device token: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Saket Bar Association',
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgotPassword.id: (context) => const ForgotPassword(),
        Dashboard.id: (context) => const Dashboard(),
        MyProfile.id: (context) => const MyProfile(),
        Events.id: (context) => const Events(),
        SearchMembers.id: (context) => const SearchMembers(),
        Subscriptions.id: (context) => const Subscriptions(),
        Circulars.id: (context) => const Circulars(),
        Links.id: (context) => const Links(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
