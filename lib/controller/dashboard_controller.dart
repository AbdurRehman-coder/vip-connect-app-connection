import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vip_connect/screens/post/create_post_main_screen.dart';
import 'package:vip_connect/utils/util.dart';

class DashboardController extends GetxController implements GetxService {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  updateCurrentIndex(int value) {
    if (value != 2) {
      currentIndex.value = value;
      update();
    } else {
      // Util.showAddPostBottomSheet();
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => CreatePostMainScreen()));
    }
  }

  updateIsLoading(bool value) {
    isLoading.value = value;
    update();
  }
}
