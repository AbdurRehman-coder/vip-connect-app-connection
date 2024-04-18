import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';

import '../../../../constants.dart';
import '../../../../helper/app_text_styles.dart';
import '../../../components/spacer.dart';
import '../vip_module/vip_screen.dart';

class ShowPostUserProfile extends StatefulWidget {
  ShowPostUserProfile({Key? key}) : super(key: key);

  @override
  State<ShowPostUserProfile> createState() => _ShowPostUserProfileState();
}

class _ShowPostUserProfileState extends State<ShowPostUserProfile> {
  String userUid = '';

  /// get user profile stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> get getUserProfileStream {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userUid)
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userUid = Get.arguments[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: 'User Profile'),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 50),
        child: Container(
          height: double.infinity.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.black800,
            borderRadius: BorderRadius.circular(kBorderRadius22),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: StreamBuilder(
              stream: getUserProfileStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 153.h,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(kBorderRadius22),
                                  ),
                                  child: Image.asset(
                                    AppAssets.bgImg,
                                    fit: BoxFit.cover,
                                    height: 100.h,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: 20.h,
                              //   right: 17.w,
                              //   child: Image.asset(
                              //     AppAssets.linkedinLogoImg,
                              //     height: 35.h,
                              //     width: 35.w,
                              //   ),
                              // ),
                              Positioned.fill(
                                top: 31.h,
                                child: Center(
                                  child: Container(
                                    height: 145.h,
                                    width: 145.h,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.white300,
                                      border: Border.all(
                                          color: AppColors.white300,
                                          width: 4.w),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!['profileImage']
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            // colorFilter:
                                            // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AppAssets.dummyPostImg,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalSpacer(height: 17.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${snapshot.data!['firstName'].toString()} ${snapshot.data!['lastName'].toString()}",
                              maxLines: 1,
                              style: AppTextStyle.popping24_600,
                            ),
                            VerticalSpacer(height: 5.h),
                            Text(
                              '${snapshot.data!['jobTitle']} ',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.popping18_400,
                            ),
                            VerticalSpacer(height: 5.h),
                            Text('@ ${snapshot.data!['employerName']} ',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: AppTextStyle.bodyRegular.copyWith(
                                  color: AppColors.white500,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpacer(height: 22.h),
                            CustomSvgAndText(
                              title:
                                  "${snapshot.data!['cityName']}, ${snapshot.data!['stateName']}",
                              svgPath: AppAssets.locationSvg,
                              style: AppTextStyle.popping16_400,
                              size: 24.h,
                            ),
                            // VerticalSpacer(height: 12.h),
                            // CustomSvgAndText(
                            //   title: "Music, Books Read, Music",
                            //   svgPath: AppAssets.musicSvg,
                            //   style: AppTextStyle.popping16_400,
                            //   size: 24.h,
                            // ),
                            VerticalSpacer(height: 24.h),
                            Text(
                              '${snapshot.data!['bio']} ',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bodyRegular.copyWith(
                                color: AppColors.white500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 150,
                        ),

                        /// Todo: Connection button
                        // SizedBox(
                        //   width: 185.w,
                        //   child: CommonButton(
                        //     title: AppTexts.connect,
                        //     iconData: '',
                        //     height: 40.h,
                        //     borderRadius: kBorderRadius8,
                        //     padding: EdgeInsets.zero,
                        //     isFill: true,
                        //     bgColor: AppColors.black800,
                        //     borderColor: AppColors.primary,
                        //     isIconVisible: false,
                        //     style: AppTextStyle.rubik12_600
                        //         .copyWith(fontSize: kFontSize18),
                        //     onPressed: () {
                        //       Util.showToast(AppTexts.connectionRequestSent);
                        //     },
                        //     iconColor: AppColors.transparent,
                        //     buttonShouldDisable: false,
                        //   ),
                        // ),
                        VerticalSpacer(height: 24.h),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
