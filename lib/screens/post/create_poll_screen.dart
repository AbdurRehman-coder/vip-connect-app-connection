import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart' as locate;
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/create_post_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../controller/post_controller.dart';
import '../../model/post_model.dart';
import '../../services/firebase_auth.dart';

class CreatePollScreen extends StatefulWidget {
  CreatePollScreen({Key? key}) : super(key: key);

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  String dropdownValue = '1 day';
  RxBool showPollPostView = false.obs;
  final CreatePostController pollController = Get.find();
  final PostController _postController = Get.find();
  TextEditingController pollDescriptionController = TextEditingController();
  locate.Location location = locate.Location();

  /// to disable post button after clicked once
  bool isPostButtonClicked = true;
  @override
  Widget build(BuildContext context) {
    print(
        'poll controllers length: ${pollController.listPollTextControllers.length}');
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: AppTexts.createAPoll),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Obx(() =>
                // showPollPostView.isFalse ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Add your poll question/Description
                    CustomTextField(
                      controller: pollDescriptionController,
                      mainTitle: 'Your question',
                      hintText: 'Your question',
                      maxLines: 4,
                      filled: true,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {
                        // pollDescriptionController.text = newValue!;
                        setState(() {});
                      },
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${pollDescriptionController.text.length}/140",
                        style: AppTextStyle.popping12_300.copyWith(
                          color: AppColors.white500,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: pollController.listPollTextControllers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            CustomTextField(
                              controller:
                                  pollController.listPollTextControllers[index],
                              mainTitle: "Option ${index + 1}",
                              hintText: 'Add option',
                              filled: true,
                              fillColor: AppColors.primary,
                              onSaved: (String? newValue) {},
                              validator: (String? value) {},
                            ),
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${pollController.listPollTextControllers[index].text.length}/30",
                                style: AppTextStyle.popping12_300.copyWith(
                                  color: AppColors.white500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // SizedBox(height: 18.h),
                    // CustomTextField(
                    //   mainTitle: "Option 2",
                    //   hintText: 'Add option',
                    //   filled: true,
                    //   fillColor: AppColors.primary,
                    //   onSaved: (String? newValue) {},
                    //   validator: (String? value) {},
                    // ),
                    // SizedBox(height: 8.h),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Text(
                    //     "0/30",
                    //     style: AppTextStyle.popping12_300.copyWith(
                    //       color: AppColors.white500,
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 9.h),

                    /// Add Button
                    GestureDetector(
                      onTap: () {
                        pollController
                            .addPollTextControllers(TextEditingController());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 23.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(kBorderRadius20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.plusSvg,
                              color: AppColors.secondary,
                              height: 24.h,
                              width: 24.w,
                            ),
                            HorizontalSpacer(width: 5.w),
                            Text(
                              'Add option',
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColors.secondary),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      AppTexts.pollDuration,
                      style: AppTextStyle.bodyRegular
                          .copyWith(color: AppColors.primary),
                    ),
                    SizedBox(height: 13.h),

                    /// Duration Drop down form field
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        filled: true,
                        fillColor: AppColors.primary,
                      ),
                      dropdownColor: AppColors.primary,
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['1 day', '3 days', '7 days', '2 weeks']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: AppTextStyle.bodyRegular
                                .copyWith(color: AppColors.hintText),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )),
            SizedBox(height: 24.h),
            CommonButton(
              title: AppTexts.post,
              iconData: '',
              height: 55.h,
              isFill: true,
              isIconVisible: false,
              iconColor: AppColors.transparent,
              buttonShouldDisable: false,
              onPressed: isPostButtonClicked == true
                  ? () async {
                      /// Get the user location at the time when it post this
                      /// we getting only main city and its state
                      locate.LocationData _locationData;
                      _locationData = await location.getLocation();
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              _locationData.latitude!,
                              _locationData.longitude!);

                      DateTime expireDateTime =
                          Jiffy(DateTime.now()).add(days: 1).dateTime;
                      if (dropdownValue == '1 day') {
                        expireDateTime =
                            Jiffy(DateTime.now()).add(days: 1).dateTime;
                      } else if (dropdownValue == '3 days') {
                        expireDateTime =
                            Jiffy(DateTime.now()).add(days: 3).dateTime;
                      } else if (dropdownValue == '7 days') {
                        expireDateTime =
                            Jiffy(DateTime.now()).add(days: 7).dateTime;
                      } else if (dropdownValue == '2 weeks') {
                        expireDateTime =
                            Jiffy(DateTime.now()).add(days: 14).dateTime;
                      }
                      setState(() {
                        isPostButtonClicked = false;
                      });

                      pollController.listPollTextControllers
                          .forEach((textController) {});

                      ///Button onTap
                      /// Get posts documents length, for post id
                      final QuerySnapshot qSnap = await FirebaseFirestore
                          .instance
                          .collection('posts')
                          .get();
                      final int documentsLength = qSnap.docs.length;

                      _postController.updateIsLoading(true);
                      // Get.back();
                      String imageURL = '';
                      User? user = FirebaseAuth.instance.currentUser;

                      PostModel postModel = PostModel(
                        id: documentsLength + 1,
                        uid: AuthServices().user?.uid.toString(),
                        createdAt: Timestamp.now(),
                        pollExpireDate: expireDateTime,
                        postDescription:
                            pollDescriptionController.text.toString(),
                        postType: 'poll',
                        postAddress:
                            '${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}',
                        likes: [],
                        dislikes: [],
                        shares: [],
                        comments: [],
                        // voters: [],
                        pollsList: [],
                        postImage: null,
                        options: pollController.listPollTextControllers
                            .map(
                              (txtController) => PollOptions(
                                option: pollController.listPollTextControllers
                                        .indexOf(txtController) +
                                    1,
                                optionDescription: txtController.text,
                                votes: 0,
                              ),
                            )
                            .toList(),
                      );

                      pollController.createPoll(postModel).then((value) {
                        pollDescriptionController.clear();
                      });
                      _postController.updateIsLoading(false);

                      // if (showPollPostView.isFalse) {
                      //   showPollPostView.value = true;
                      // } else {
                      //   Get.find<DashboardController>().updateCurrentIndex(0);
                      //   Get.back();
                      // }
                      // Get.back();
                    }
                  : () {},
            ),
            SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
