import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' as isWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/services/firebase_auth.dart';
import 'package:vip_connect/services/notification_services.dart';
import 'package:vip_connect/theme/themes.dart';
import 'package:vip_connect/utils/util.dart';

import 'config/routes.dart';
import 'helper/get_di.dart';

/// Background notification handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// Handle the message
  print("Background message received: ${message.notification?.title}");
  if (message.notification != null) {
    RemoteNotification? remoteNotification = message.notification;

    /// Show a foreground notification
    // showForegroundNotification(message);
    NotificationServices.instance.showNotifications(
      remoteNotification!,
    );
  }
}

Future<void> main() async {
  /// Make sure to initialize the firebase before using it
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    /// Initialize messaging and listen for remote messages
    initMessaging();
    getCurrentLocation();
    // NotificationServices.instance.initMessaging();

    /// Initialize flutter local notifications
    NotificationServices.instance.initializeLocalNotifications();
    runApp(const MyApp());
  });
}

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('user');
final user = FirebaseAuth.instance.currentUser;
final userId = user?.uid;

/// Listen for fcmToken Refreshing
void initMessaging() async {
  // NotificationServices.instance.setupInteractedMessage();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  String? apnToken = await FirebaseMessaging.instance.getAPNSToken();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  final currentUserDoc = await userCollection.doc(userId).get();
  String storedFcmToken = currentUserDoc['fcmToken'];

  /// Configure the app to receive messages in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'on foreground called...... ${message.data} ,, ${message.notification}');
    // Handle the message
    if (message.notification != null) {
      RemoteNotification? remoteNotification = message.notification;
      print(
          'on foreground called. message body: ${message.notification?.body}');

      /// Show a foreground notification
      // showForegroundNotification(message);
      NotificationServices.instance.showNotifications(
        remoteNotification!,
      );

      /// show a notification at top of screen.
      // showSimpleNotification(Text("this is a message from simple notification"),
      //     background: Colors.green);
    }
  });

  /// Configure the app to receive messages in the background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // For handling notification when the app is in background
  // but not terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('on message opened notification called.. ${message.data}');

    /// Handle the message
    if (message.notification != null) {
      RemoteNotification? remoteNotification = message.notification;
      print('terminated/killed notification: ${message.notification?.body}');

      /// Show a foreground notification
      // showForegroundNotification(message);
      NotificationServices.instance.showNotifications(
        remoteNotification!,
      );
    }
  });

  /// Request permission to send notifications
  messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  /// Update The FCMTOKEN manually
  if (fcmToken != storedFcmToken) {
    print('yes both fcm are not equal...');

    /// Update the FCM token in Firestore inside user collection
    await FirebaseFirestore.instance.collection('user').doc(userId).update(
      {'fcmToken': fcmToken},
    ).onError((error, stackTrace) {
      print('fcmToken is not updating error...');
    });
  }

  /// Listen for token refreshes
  // messaging.onTokenRefresh.listen((String token) async {
  //   // Retrieve the user ID for the currently logged-in user
  //   final user = FirebaseAuth.instance.currentUser;
  //   final userId = user?.uid;
  //   print('token is updated::: $token');
  //
  //   /// Update the FCM token in Firestore inside user collection
  //   await FirebaseFirestore.instance.collection('user').doc(userId).update(
  //     {'fcmToken': token},
  //   ).onError((error, stackTrace) {
  //     print('fcmToken is not updating error...');
  //   });
  // });
}

getCurrentLocation() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

/// Set Global key to use when we don't have context
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.secondary,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.secondary,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
        builder: ((context, child) {
          final easyLoading = EasyLoading.init();
          return StreamProvider<UserModel?>.value(
            value: AuthServices().userState,
            initialData: UserModel(),
            child: ChangeNotifierProvider(
              create: (context) => SignUpUserInfoController(),
              child: OverlaySupport.global(
                child: GetMaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    ScreenUtil.init(
                      context,
                      designSize: isWeb.kIsWeb
                          ? Size(1440, 1082)
                          : const Size(375, 812),
                    );
                    child = easyLoading(context, child);
                    Util.setEasyLoading();
                    return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child,
                    );
                  },
                  theme: kAppTheme,
                  getPages: Routes.routes,
                  initialRoute: GetPlatform.isWeb ? routeLoginWeb : routeSplash,
                  defaultTransition: Transition.native,
                  transitionDuration: const Duration(milliseconds: 400),
                  // initialRoute: AddPetsScreen.routeName,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

///vip connect bundle identifier for ios
//'com.vipconnect.app.vipConnect'
/// APNs Server key for FCM
// key iD: 3PR69TWC7L
