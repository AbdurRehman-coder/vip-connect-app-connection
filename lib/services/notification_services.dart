import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';

class NotificationServices {
  /// Making it Singleton Design Pattern
  NotificationServices._privateConstructor();

  /// getter for this singleton class
  static final NotificationServices instance =
      NotificationServices._privateConstructor();

  /// create instance of Flutter Local Notification
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// this method is used to initialize android and iOS
  /// For Notification initialization we create NotificationInitializationSettings
  void initializeLocalNotifications() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iOSinitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      // requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSinitializationSettings,
    );
    bool? isNotificationInitialized =
        await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

      /// this method is used for when click on notification from background
      //         onDidReceiveNotificationResponse: (response) {
      //   print('clicked on notification from background: ${response}');
      // },
    );

    log('notification initialized: ${isNotificationInitialized}');
  }

  /// For Notification show we create NotificationDetails
  void showNotifications(RemoteNotification remoteNotification) async {
    print(
        'notification show called... ${remoteNotification.body}, ${remoteNotification.title}, ${remoteNotification.hashCode}');

    /// For Android
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'vip_connect_notifications',
      'vip_connect_channel',
      importance: Importance.max,
      priority: Priority.max,
    );

    /// For iOS
    DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      remoteNotification.hashCode,
      remoteNotification.title,
      remoteNotification.body,
      notificationDetails,
    );
  }

  /// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      if (initialMessage.data['type'] == 'chat') {
        Get.toNamed(routeChatScreen);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ChatMainScreen()));
      }
    }
    // handleMessage(initialMessage);

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('on message=...... ${message.data['type']}');
      if (message != null) {
        if (message.data['type'] == 'chat') {
          Get.toNamed(routeChatScreen);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => ChatMainScreen()));
        }
      }
    });
  }

  void handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {}
  }

  // /// Listen for fcmToken Refreshing
  // void initMessaging() async {
  //   // NotificationServices.instance.setupInteractedMessage();
  //   print('init messaging');
  //   final FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   /// Configure the app to receive messages in the foreground
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print(
  //         'on foreground called...... ${message.data} ,, ${message.notification}');
  //     // Handle the message
  //     if (message.notification != null) {
  //       RemoteNotification? remoteNotification = message.notification;
  //       print('foreground notification: ${message.notification?.body}');
  //
  //       /// Show a foreground notification
  //       // showForegroundNotification(message);
  //       NotificationServices.instance.showNotifications(
  //         remoteNotification!,
  //       );
  //
  //       /// show a notification at top of screen.
  //       // showSimpleNotification(Text("this is a message from simple notification"),
  //       //     background: Colors.green);
  //     }
  //   });
  //
  //   /// Configure the app to receive messages in the background
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   // For handling notification when the app is in background
  //   // but not terminated
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('on message opened notification called.. ${message.data}');
  //
  //     /// Handle the message
  //     if (message.notification != null) {
  //       RemoteNotification? remoteNotification = message.notification;
  //       print('terminated/killed notification: ${message.notification?.body}');
  //
  //       /// Show a foreground notification
  //       // showForegroundNotification(message);
  //       NotificationServices.instance.showNotifications(
  //         remoteNotification!,
  //       );
  //     }
  //   });
  //
  //   /// Request permission to send notifications
  //   messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //
  //   /// Listen for token refreshes
  //   messaging.onTokenRefresh.listen((String token) async {
  //     // Retrieve the user ID for the currently logged-in user
  //     final user = FirebaseAuth.instance.currentUser;
  //     final userId = user?.uid;
  //
  //     /// Update the FCM token in Firestore inside user collection
  //     await FirebaseFirestore.instance.collection('user').doc(userId).update(
  //       {'fcmToken': token},
  //     ).onError((error, stackTrace) {
  //       print('fcmToken is not updating error...');
  //     });
  //   });
  // }
  //
  // /// Background notification handler
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   /// Handle the message
  //   print("Background message received: ${message.notification?.title}");
  //   if (message.notification != null) {
  //     RemoteNotification? remoteNotification = message.notification;
  //
  //     /// Show a foreground notification
  //     // showForegroundNotification(message);
  //     NotificationServices.instance.showNotifications(
  //       remoteNotification!,
  //     );
  //   }
  // }
}

// <meta-data
// android:name="com.google.firebase.messaging.default_notification_channel_id"
// android:value="high_importance_channel" />
// <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
// android:exported="true">
// </receiver>
