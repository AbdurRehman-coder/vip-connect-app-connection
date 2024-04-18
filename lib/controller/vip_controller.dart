import 'package:get/get.dart';

class VipController extends GetxController {
  RxString searchText = ''.obs;

  setSearchText(String value) {
    searchText.value = value;
    update();
  }
}
