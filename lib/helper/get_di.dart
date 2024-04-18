import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vip_connect/controller/dashboard_controller.dart';

Future<void> init() async {
  // Controller
  Get.lazyPut(() => DashboardController());

  await Hive.initFlutter();

  // Hive.registerAdapter<UserModel>(UserModelAdapter());
  //
  // await Hive.openBox<UserModel>(AppTexts.hiveUserModel);
  // await Hive.openBox(AppTexts.hiveIsLogin);
  // await Hive.openBox(AppTexts.hiveIsGuest);
  // await Hive.openBox(AppTexts.hiveToken);
  // await Hive.openBox(AppTexts.hiveCurrentWorkingUrl);

  FlutterNativeSplash.remove();
}
