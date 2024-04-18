import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_connect/controller/user_profile_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({
    Key? key,
  }) : super(key: key);
  // DocumentSnapshot<Map<String, dynamic>>? userDocSnapshot;
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final userProfileController = Get.put(UserProfileController());

  /// TextEditing Controller
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _jobTitleController;
  TextEditingController? _employerController;
  TextEditingController? _cityController;
  TextEditingController? _stateController;
  TextEditingController? _bioController;

  dynamic getArgument = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// assign values to textfields
    _firstNameController =
        TextEditingController(text: getArgument['firstName']);
    _lastNameController = TextEditingController(text: getArgument['lastName']);
    _jobTitleController = TextEditingController(text: getArgument['jobTitle']);
    _employerController =
        TextEditingController(text: getArgument['employerName']);
    _cityController = TextEditingController(text: getArgument['cityName']);
    _stateController = TextEditingController(text: getArgument['stateName']);
    _bioController = TextEditingController(text: getArgument['bio']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _jobTitleController?.dispose();
    _employerController?.dispose();
    _cityController?.dispose();
    _stateController?.dispose();
    _bioController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'user profile picked image: ${userProfileController.pickedImage.value.path}');
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: AppTexts.updateProfile),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Center(
              child: Obx(() {
                return Stack(
                  children: [
                    Container(
                      height: 145.h,
                      width: 145.h,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white300,
                        border:
                            Border.all(color: AppColors.white300, width: 4.w),
                        // image: DecorationImage(
                        //   image: AssetImage(
                        //     // AppAssets.dummyPostImg,
                        //     userProfileController.pickedImage.value.path
                        //   ),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: userProfileController
                              .pickedImage.value.path.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(userProfileController
                                    .pickedImage.value.path),
                                // imageProvider,
                                height: 110.0,
                                width: 110.0,
                                fit: BoxFit.cover,
                              ))
                          : Image.asset(
                              AppAssets.dummyPostImg,
                            ),
                    ),
                    Positioned(
                      right: 10.w,
                      bottom: 10.h,
                      child: GestureDetector(
                        onTap: () {
                          userProfileController.chooseProfileImageDestination();
                        },
                        child: Container(
                          height: 26.h,
                          width: 26.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary,
                            border: Border.all(
                                color: AppColors.white300, width: 2.w),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.cameraCircleSvg,
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 24.h),
            CustomTextField(
              controller: _firstNameController,
              mainTitle: AppTexts.firstName,
              // hintText: AppTexts.enter + AppTexts.firstName,
              hintText: getArgument['firstName'].toString(),
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),
            VerticalSpacer(height: 10.h),
            CustomTextField(
              controller: _lastNameController,
              mainTitle: AppTexts.lastName,
              hintText: getArgument['lastName'].toString(),
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              controller: _jobTitleController,
              mainTitle: AppTexts.jobTitle,
              hintText: getArgument['jobTitle'] ?? ' ',
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              controller: _employerController,
              mainTitle: AppTexts.company,
              hintText: getArgument['employerName'] ?? ' ',
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),

            /// City
            SizedBox(height: 10.h),
            CustomTextField(
              controller: _cityController,
              mainTitle: 'City',
              hintText: getArgument['cityName'] ?? ' ',
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),

            /// State
            SizedBox(height: 10.h),
            CustomTextField(
              controller: _stateController,
              mainTitle: 'State',
              hintText: getArgument['stateName'] ?? ' ',
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              controller: _bioController,
              mainTitle: AppTexts.bio,
              hintText: getArgument['bio'] ?? ' ',
              obscureText: false,
              maxLines: 4,
              filled: true,
              fillColor: AppColors.primary,
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),
            SizedBox(height: 24.h),
            Obx(() {
              return userProfileController.isLoading.value
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    )
                  : CommonButton(
                      title: AppTexts.save,
                      iconData: '',
                      isFill: true,
                      isIconVisible: false,
                      onPressed: () {
                        // Get.back();
                        userProfileController.updateUserProfileDataAndImage(
                          context: context,
                          firstName: _firstNameController!.text,
                          lastName: _lastNameController!.text,
                          jobTitle: _jobTitleController!.text,
                          employerName: _employerController!.text,
                          cityName: _cityController!.text,
                          stateName: _stateController!.text,
                          bio: _bioController!.text,
                        );

                        /// clear all text controllers and image
                        userProfileController.setUserImage(XFile(''));
                        _firstNameController?.clear();
                        _lastNameController?.clear();
                        _jobTitleController?.clear();
                        _employerController?.clear();
                        _cityController?.clear();
                        _stateController?.clear();
                        _bioController?.clear();

                        // Get.offAndToNamed(showUserProfile);
                      },
                      iconColor: AppColors.transparent,
                      buttonShouldDisable: false,
                    );
            }),
          ],
        ),
      ),
    );
  }
}
