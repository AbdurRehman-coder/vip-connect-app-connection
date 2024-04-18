import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:vip_connect/model/post_model.dart';

class SignUpUserInfoController extends ChangeNotifier {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  setFirstName(String value) {
    firstNameController.text = value;
    notifyListeners();
  }

  setLastName(String value) {
    lastNameController.text = value;
    notifyListeners();
  }

  setJobTitle(String value) {
    jobTitleController.text = value;
    notifyListeners();
  }

  setEmployerController(String value) {
    employerController.text = value;
    notifyListeners();
  }

  setCityController(String value) {
    cityController.text = value;
    notifyListeners();
  }

  setStateController(String value) {
    stateController.text = value;
    notifyListeners();
  }

  setBioController(String value) {
    bioController.text = value;
    notifyListeners();
  }

  setIndustryController(String value) {
    industryController.text = value;
    notifyListeners();
  }

  setEmailController(String value) {
    emailController.text = value;
    notifyListeners();
  }

  setPasswordController(String value) {
    passController.text = value;
    notifyListeners();
  }

  setConfirmPasswordController(String value) {
    confirmPassController.text = value;
    notifyListeners();
  }

  clearAllSignUpTextFieldControllers() {
    firstNameController.clear();
    lastNameController.clear();
    firstNameController.clear();
    jobTitleController.clear();
    employerController.clear();
    bioController.clear();
    industryController.clear();
    emailController.clear();
    passController.clear();
    confirmPassController.clear();
  }

  /// This is used for reposting/ share widget
  PostModel sharePostModel = PostModel();
  setSharedPostModel(PostModel model) {
    sharePostModel = model;
    notifyListeners();
  }

  /// Video player controller
  VideoPlayerController? videoController;
}
