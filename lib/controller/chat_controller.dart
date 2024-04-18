import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/model/user_model.dart';

class ChatController extends GetxController {
  RxList<UserModel> userModelList = <UserModel>[].obs;
  RxList<String> selectedUserUIDs = <String>[].obs;

  setUserModelList(UserModel user) {
    if (!selectedUserUIDs.contains(user.uid)) {
      userModelList.add(user);
    }
    update();
  }

  removeUserModel(UserModel user) {
    userModelList.remove(user);
    selectedUserUIDs.removeWhere((element) => element == user.uid);
    update();
  }

  setSelectedUserUIDS(String userUID) {
    if (!selectedUserUIDs.contains(userUID)) {
      selectedUserUIDs.add(userUID);
    }
    update();
  }

  RxString secondUserUid = ''.obs;
  setSecondUserUid(String value) {
    secondUserUid.value = value;
    update();
  }

  /// Image picker from gallery and camera
  final picker = ImagePicker();

  /// Image
  Rx<XFile> pickedImage = XFile('').obs;
  // XFile? get userImage.obx => _image;
  setUserImage(XFile? image) {
    pickedImage.value = image!;
    update();
    // notifyListeners();
  }

  Future getChatImageFromGallery() async {
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      final croppedImage = await cropImage(imageFile: imagePicker);
      // setUserImage(XFile(imagePicker.path));
      if (croppedImage != null) {
        setUserImage(croppedImage);
        Get.toNamed(routeImageMessage);
      } else {
        print('crop image null');
      }
    }
  }

  Future getChatImageFromCamera() async {
    final imagePicker = await picker.pickImage(source: ImageSource.camera);
    if (imagePicker != null) {
      final croppedImage = await cropImage(imageFile: imagePicker);
      // setUserImage(XFile(imagePicker.path));
      if (croppedImage != null) {
        setUserImage(croppedImage);
        Get.toNamed(routeImageMessage);
      } else {
        print('crop image null');
      }
    }
    // if (imagePicker != null) {
    //   setUserImage(XFile(imagePicker.path));
    // }
  }

  /// Crop the the picked image for profile
  Future<XFile?> cropImage({required XFile imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return XFile(croppedImage.path);
  }

  void chooseMessageImageDestination() {
    BuildContext? getContext = Get.context;
    showDialog(
        context: getContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 150.h,
              decoration: BoxDecoration(
                // color: AppColors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '      Select image from: ',
                    style: TextStyle(color: Colors.black),
                  ),
                  ListTile(
                    onTap: () {
                      getChatImageFromCamera();
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      getChatImageFromGallery();
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
