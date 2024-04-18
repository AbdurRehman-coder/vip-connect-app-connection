import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';

import '../../../../helper/app_text_styles.dart';
import '../../../../services/firebase_auth.dart';

class ShowUserProfileScreen extends StatelessWidget {
  ShowUserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: 'User Profile'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: StreamBuilder(
            stream: AuthServices().getUserProfileStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 70,
                        ),

                        /// User Image widget
                        Center(
                          child: Container(
                            height: 145.h,
                            width: 145.h,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white300,
                              border: Border.all(
                                  color: AppColors.white300, width: 4.w),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data!['profileImage'].toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    // colorFilter:
                                    // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Image.asset(
                                AppAssets.dummyPostImg,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // appProvider.editProfile();
                            Get.toNamed(routeUpdateProfile,
                                arguments: snapshot.data);
                          },
                          child: Container(
                            // color: Colors.red,
                            height: 50.h,
                            width: 90.w,
                            child: Row(
                              children: [
                                Text(
                                  'Edit',
                                  style: AppTextStyle.h3.copyWith(
                                      color: AppColors.white300,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    CustomTextField(
                      mainTitle: 'First Name',
                      hintText: snapshot.data!['firstName'].toString(),
                      filled: true,
                      fillColor: AppColors.primary,
                      enabled: false,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: 'Last Name',
                      hintText: snapshot.data!['lastName'].toString(),
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: 'Job Title',
                      hintText: snapshot.data!['jobTitle'].toString(),
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: 'Company',
                      hintText: snapshot.data!['employerName'].toString(),
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),

                    /// City
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: 'City',
                      hintText: snapshot.data!['cityName'].toString(),
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),

                    /// State
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: 'State',
                      hintText: snapshot.data!['stateName'].toString(),
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: 'Bio',
                      hintText: snapshot.data!['bio'].toString(),
                      obscureText: false,
                      maxLines: 4,
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 24.h),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                        ),

                        /// User Image widget
                        Center(
                          child: Container(
                            height: 145.h,
                            width: 145.h,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white300,
                              border: Border.all(
                                  color: AppColors.white300, width: 4.w),
                              image: const DecorationImage(
                                image: AssetImage(
                                  AppAssets.dummyPostImg,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // appProvider.editProfile();
                            Get.toNamed(routeUpdateProfile);
                          },
                          child: Container(
                            // color: Colors.red,
                            height: 50.h,
                            width: 90.w,
                            child: Row(
                              children: [
                                Text(
                                  'Edit',
                                  style: AppTextStyle.h3.copyWith(
                                      color: AppColors.white300,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    CustomTextField(
                      mainTitle: AppTexts.firstName,
                      hintText: 'first name',
                      filled: true,
                      fillColor: AppColors.primary,
                      enabled: false,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: AppTexts.lastName,
                      hintText: 'last name',
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: AppTexts.jobTitle,
                      hintText: 'job title',
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: AppTexts.company,
                      hintText: 'employer name',
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      mainTitle: AppTexts.bio,
                      hintText: 'bio',
                      obscureText: false,
                      maxLines: 4,
                      filled: true,
                      enabled: false,
                      fillColor: AppColors.primary,
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    SizedBox(height: 24.h),
                  ],
                );
              }
            }),
      ),
    );
  }
}
