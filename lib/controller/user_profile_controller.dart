import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../config/routes.dart';

class UserProfileController extends GetxController {
  RxBool isLoading = false.obs;
  updateIsLoading(bool value) {
    isLoading.value = value;
    update();
  }

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString jobTitle = ''.obs;
  RxString employerName = ''.obs;
  RxString cityName = ''.obs;
  RxString stateName = ''.obs;
  RxString bioText = ''.obs;
  RxString industryName = ''.obs;
  RxString userEmail = ''.obs;

  setUserInformation({
    String? firstN,
    String? lastN,
    String? jobT,
    String? employerN,
    String? city,
    String? state,
    String? bioT,
    String? industryN,
    String? email,
  }) {
    firstName.value = firstN!;
    lastName.value = lastN!;
    jobTitle.value = jobT!;
    employerName.value = employerN!;
    cityName.value = city!;
    stateName.value = state!;
    bioText.value = bioT!;
    industryName.value = industryN ?? '';
    userEmail.value = email!;
    update();
  }

  /// Store User data for switching between screens
  // Rx<TextEditingController> firstNameController = TextEditingController().obs;
  // Rx<TextEditingController> lastNameController = TextEditingController().obs;
  // Rx<TextEditingController> jobTitleController = TextEditingController().obs;
  // Rx<TextEditingController> employerController = TextEditingController().obs;
  // Rx<TextEditingController> bioController = TextEditingController().obs;
  // Rx<TextEditingController> industryController = TextEditingController().obs;
  // Rx<TextEditingController> emailController = TextEditingController().obs;
  // Rx<TextEditingController> passController = TextEditingController().obs;
  // Rx<TextEditingController> confirmPassController = TextEditingController().obs;

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

  Future getProfileImageFromGallery() async {
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      final croppedImage = await cropImage(imageFile: imagePicker);
      // setUserImage(XFile(imagePicker.path));
      if (croppedImage != null) {
        setUserImage(croppedImage);
      } else {
        print('crop image null');
      }
    }
  }

  Future getProfileImageFromCamera() async {
    final imagePicker = await picker.pickImage(source: ImageSource.camera);
    if (imagePicker != null) {
      final croppedImage = await cropImage(imageFile: imagePicker);
      // setUserImage(XFile(imagePicker.path));
      if (croppedImage != null) {
        setUserImage(croppedImage);
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

  void chooseProfileImageDestination() {
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
                      getProfileImageFromCamera();
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
                      getProfileImageFromGallery();
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

  void updateUserProfileDataAndImage({
    BuildContext? context,
    required String firstName,
    required String lastName,
    required String jobTitle,
    required String employerName,
    required String cityName,
    required String stateName,
    required String bio,
  }) async {
    updateIsLoading(true);
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (pickedImage.value.path.isNotEmpty) {
      /// Create a Reference to the file
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user')
          .child('/profileImage${currentUser?.uid}');

      /// upload the image
      UploadTask uploadTask = storageRef.putFile(File(pickedImage.value.path));
      await Future.value(uploadTask);
      final String newURL = await storageRef.getDownloadURL();

      /// Now update the user object inside firestore and put the url of new uploaded image
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({'profileImage': newURL.toString()}).then((value) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text('user updated successfully'),
          ),
        );
        updateIsLoading(false);
      }).onError((error, stackTrace) {
        // Utils.showSnackBar("User not updated", Colors.black);
        updateIsLoading(false);
      });
    }

    /// Update User first name
    if (firstName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'firstName': firstName.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('firstName updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }

    /// Update User first name
    if (lastName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'lastName': lastName.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('lastName updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }

    /// Update User job title
    if (jobTitle.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'jobTitle': jobTitle.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('jobTitle updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }

    /// Update User employer name
    if (employerName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'employerName': employerName.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('emp updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }

    /// Update User city name
    if (cityName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'cityName': cityName.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('emp updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }

    /// Update User state name
    if (stateName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'stateName': stateName.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('emp updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }

    /// Update User Bio
    if (bio.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'bio': bio.toString(),
      }).then((value) {
        updateIsLoading(false);
        // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('emp updated successfully'),),);
      }).onError((error, stackTrace) {
        updateIsLoading(false);
        // Utils.showSnackBar("User not updated", Colors.black);
      });
    }
    Get.offAndToNamed(showUserProfile);

    // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('user updated successfully'),),);
    updateIsLoading(false);
  }
}
