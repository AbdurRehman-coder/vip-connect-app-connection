import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../../../config/routes.dart';
import '../../../../helper/app_assets.dart';
import '../../../../model/user_model.dart';
import '../../../../services/firebase_auth.dart';
import '../../../../services/vip_connection_services.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  /// create instance of ConnectionService()
  ConnectionService _connectionService = ConnectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: AppTexts.notifications),
      backgroundColor: AppColors.secondary,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer(height: 22.h),
            Text(
              AppTexts.news,
              style: AppTextStyle.h3.copyWith(
                fontSize: kFontSize20,
                fontWeight: FontWeight.w500,
                color: AppColors.white300,
              ),
            ),
            VerticalSpacer(height: 16.h),

            StreamBuilder<List<UserModel>>(
              stream: _connectionService.getIncomingConnectionRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No user...',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    UserModel? userModel = snapshot.data?[index];

                    // UserModel userModel =
                    //     UserModel.fromJson(document! as Map<String, dynamic>);

                    final currentUser = AuthServices().user;

                    return currentUser?.uid != userModel?.uid
                        ? Column(
                            children: [
                              /// User Profile
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(routeMessage,
                                        arguments: {'userID': userModel?.uid});
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 55.h,
                                        width: 55.h,
                                        child: CircleAvatar(
                                          /// User  picture inside post
                                          child: userModel?.profileImage != null
                                              ? CachedNetworkImage(
                                                  imageUrl: userModel!
                                                      .profileImage
                                                      .toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
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
                                                              CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    AppAssets.logoImg,
                                                  ),
                                                )
                                              : Image.asset(
                                                  AppAssets.logoImg,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// User name
                                            Text(
                                              userModel?.firstName != null
                                                  ? '${userModel?.firstName} ${userModel?.lastName}'
                                                  : "Jonathan Cooper",
                                              style: AppTextStyle.bodyMedium,
                                              // style: AppTextStyle.bodyMedium.copyWith(
                                              //   fontSize: kFontSize11,
                                              //   fontWeight: FontWeight.w600,
                                              // ),
                                            ),

                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                /// Designation text
                                                Text(
                                                  userModel?.jobTitle != null
                                                      ? '${userModel?.jobTitle}'
                                                      : " ",
                                                  style: AppTextStyle.bodyMedium
                                                      .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.white54,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),

                                                /// Company name
                                                Text(
                                                  userModel?.employerName !=
                                                          null
                                                      ? ' @ ${userModel?.employerName}'
                                                      : " ",
                                                  style: AppTextStyle.bodyMedium
                                                      .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.white54,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      _connectionService
                                                          .acceptFriendRequest(
                                                              userModel!.uid
                                                                  .toString());
                                                    },
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 18),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      _connectionService
                                                          .declineFriendRequest(
                                                              userModel!.uid
                                                                  .toString());
                                                    },
                                                    child: const Text(
                                                      'Decline',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 18),
                                                    )),
                                              ],
                                            )
                                            // Row(
                                            //   children: [
                                            //     RawMaterialButton(
                                            //       onPressed: () {
                                            //         print(
                                            //             'check button clicked');
                                            //       },
                                            //       elevation: 2.0,
                                            //       fillColor: Colors.white,
                                            //       padding: EdgeInsets.all(08.0),
                                            //       shape: const CircleBorder(),
                                            //       child: const Icon(
                                            //         Icons.check,
                                            //         size: 28.0,
                                            //       ),
                                            //     ),
                                            //     RawMaterialButton(
                                            //       onPressed: () {
                                            //         print(
                                            //             'check button cancel');
                                            //       },
                                            //       elevation: 2.0,
                                            //       fillColor: Colors.white,
                                            //       padding: EdgeInsets.all(08.0),
                                            //       shape: const CircleBorder(),
                                            //       child: const Icon(
                                            //         Icons.cancel,
                                            //         size: 28.0,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container();
                  },
                );
              },
            ),

            // ListView.builder(
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: 6,
            //     itemBuilder: (context, index) {
            //       return CustomListTile2(
            //         title: "Applied Approve!",
            //         subtitle:
            //             "Lorem ipsum dolor sit amet consecte tur. Vel mus et id pellentesque at et.",
            //         imagePath: AppAssets.tempProfileImg,
            //         onTap: () {},
            //       );
            //     }),
          ],
        ),
      ),
    );
  }
}
