import 'package:hive_flutter/hive_flutter.dart';

// import '../model/user_model.dart';
import 'app_texts.dart';

class Boxes {
  // static Box<UserModel> getUserModel() =>
  //     Hive.box<UserModel>(AppTexts.hiveUserModel);
  static Box getIsLogin() => Hive.box(AppTexts.hiveIsLogin);
  static Box getIsGuest() => Hive.box(AppTexts.hiveIsGuest);
  static Box getToken() => Hive.box(AppTexts.hiveToken);
  //Current Working Base Url
  static Box getCurrentWorkingUrl() => Hive.box(AppTexts.hiveCurrentWorkingUrl);
}
