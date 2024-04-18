import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/chat_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../../../model/user_model.dart';
import '../../../../services/firebase_auth.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({Key? key}) : super(key: key);

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  Stream<QuerySnapshot>? _searchResultsStream;
  // List<String> selectedUsersIds = [];
  // List<UserModel> userListModel = [];
  ChatController _chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    _searchResultsStream =
        FirebaseFirestore.instance.collection("user").snapshots();
    // getUserData();
  }

  // Future getUserData() async {
  //   /// Get sing user for posts
  //   final CollectionReference _userCollectionRef =
  //       FirebaseFirestore.instance.collection('user');
  //
  //   if (selectedUsersIds.isNotEmpty) {
  //     selectedUsersIds.forEach((element) async {
  //       /// Get user for post
  //       DocumentSnapshot? docSnapshot =
  //           await _userCollectionRef.doc(element).get();
  //       print('user for psot>..${docSnapshot.data()}');
  //       UserModel user =
  //           UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
  //       if (mounted) {
  //         setState(() {
  //           userListModel.add(user);
  //         });
  //       }
  //     });
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: AppTexts.newGroup),
      backgroundColor: AppColors.secondary,

      /// Floating action button which will redirect to give group a name
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.white300,
        child: SvgPicture.asset(
          AppAssets.checkmarkSvg,
          height: 24.h,
          width: 24.h,
        ),
        onPressed: () {
          Get.toNamed(
            routeNewGroupName,
          );
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacer(height: 10.h),
              CustomTextField(
                mainTitle: AppTexts.searchParticipants,
                hideMainTitle: true,
                hintText: AppTexts.searchParticipants,
                hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                  color: AppColors.white500,
                ),
                filled: true,
                fillColor: AppColors.primary,
                prefixWidget: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: SvgPicture.asset(
                    AppAssets.maskGroup2Svg,
                    color: AppColors.secondary,
                    height: 24.h,
                    width: 24.h,
                  ),
                ),
                onSaved: (String? newValue) {},
                validator: (String? value) {},
              ),
              VerticalSpacer(height: 17.h),
              Text(
                'Added Participants',
                style: AppTextStyle.rubik12_600.copyWith(
                  fontSize: kFontSize20,
                ),
              ),
              VerticalSpacer(height: 17.h),
              _chatController.userModelList.isNotEmpty
                  ? Wrap(
                      spacing: 16.w,
                      runSpacing: 20.h,
                      alignment: WrapAlignment.start,
                      children: _chatController.userModelList.map((userModell) {
                        return SizedBox(
                          height: 70.h,
                          width: 70.h,
                          child: Stack(
                            children: [
                              // ClipOval(
                              //   child: Image.network(e.profileImage.toString()),
                              // ),
                              userModell.profileImage != null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          userModell.profileImage.toString(),
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
                                              child: CupertinoActivityIndicator(
                                        color: Colors.white,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AppAssets.logoImg,
                                      ),
                                    )
                                  : Image.asset(
                                      AppAssets.logoImg,
                                    ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: InkWell(
                                    onTap: () {
                                      _chatController
                                          .removeUserModel(userModell);
                                      // userListModel.remove(userModell);
                                      // selectedUsersIds.removeWhere(
                                      //     (element) => element == userModell.uid);
                                      // setState(() {});
                                    },
                                    child: SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.white,
                                        child: SvgPicture.asset(
                                          AppAssets.closeSvg,
                                          color: AppColors.black,
                                          height: 14.h,
                                          width: 14.h,
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }).toList(),
                      // children: const [
                      // CustomImageWithClose(),
                      // CustomImageWithClose(),
                      // CustomImageWithClose(),
                      // CustomImageWithClose(),
                      // CustomImageWithClose(),
                      // CustomImageWithClose(),
                      // ],
                    )
                  : Container(),
              VerticalSpacer(height: 20.h),
              Text(
                'All Participants',
                style: AppTextStyle.rubik12_600.copyWith(
                  fontSize: kFontSize20,
                ),
              ),
              VerticalSpacer(height: 20.h),

              /// Show list of users to create group chat
              StreamBuilder<QuerySnapshot>(
                stream: _searchResultsStream,
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
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      var document = snapshot.data?.docs[index];
                      UserModel userModel = UserModel.fromJson(
                          document!.data() as Map<String, dynamic>);

                      final currentUser = AuthServices().user;
                      return currentUser?.uid != userModel.uid
                          ? Column(
                              children: [
                                /// User Profile
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(
                                    onTap: () async {
                                      /// Get sing user for posts
                                      final CollectionReference
                                          _userCollectionRef = FirebaseFirestore
                                              .instance
                                              .collection('user');

                                      /// Get user for post
                                      _userCollectionRef
                                          .doc(userModel.uid.toString())
                                          .get()
                                          .then((docSnapshot) {
                                        print(
                                            'user for psot>..${docSnapshot.data()}');

                                        UserModel user = UserModel.fromJson(
                                            docSnapshot.data()
                                                as Map<String, dynamic>);

                                        _chatController
                                            .setUserModelList(userModel);
                                        _chatController.setSelectedUserUIDS(
                                            userModel.uid!);
                                      });

                                      // Get.toNamed(routeMessage,
                                      //     arguments: {'userID': userModel.uid});
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
                                            child: userModel.profileImage !=
                                                    null
                                                ? CachedNetworkImage(
                                                    imageUrl: userModel
                                                        .profileImage
                                                        .toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                          // colorFilter:
                                                          // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
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
                                                userModel.firstName != null
                                                    ? '${userModel.firstName} ${userModel.lastName}'
                                                    : "Jonathan Cooper",
                                                style: AppTextStyle.bodyMedium,
                                                // style: AppTextStyle.bodyMedium.copyWith(
                                                //   fontSize: kFontSize11,
                                                //   fontWeight: FontWeight.w600,
                                                // ),
                                              ),

                                              Row(
                                                children: [
                                                  /// Designation text
                                                  Text(
                                                    userModel.jobTitle != null
                                                        ? '${userModel.jobTitle}'
                                                        : " ",
                                                    style: AppTextStyle
                                                        .bodyMedium
                                                        .copyWith(
                                                      fontSize: kFontSize8,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),

                                                  /// Company name
                                                  Text(
                                                    userModel.employerName !=
                                                            null
                                                        ? ' @ ${userModel.employerName}'
                                                        : " ",
                                                    style: AppTextStyle
                                                        .bodyMedium
                                                        .copyWith(
                                                      fontSize: kFontSize8,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3.h),
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
              //     shrinkWrap: true,
              //     itemCount: 7,
              //     itemBuilder: (context, index) {
              //       return const CustomParticipantsTitle();
              //     })
            ],
          );
        }),
      ),
    );
  }
}

class CustomParticipantsTitle extends StatelessWidget {
  const CustomParticipantsTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(
            height: 66.h,
            width: 66.h,
            child: Stack(
              children: [
                ClipOval(
                  child: Image.asset(AppAssets.tempProfileImg),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: SvgPicture.asset(
                    AppAssets.onlineUserSvg,
                    height: 18.h,
                    width: 18.h,
                  ),
                ),
              ],
            ),
          ),
          HorizontalSpacer(width: 18.w),
          Expanded(
            child: Text(
              "Todd Peterson",
              style: AppTextStyle.popping18_400,
            ),
          ),
          SvgPicture.asset(
            AppAssets.checkmarkCircleSvg,
            height: 24.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }
}

class CustomImageWithClose extends StatelessWidget {
  const CustomImageWithClose({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 70.h,
      child: Stack(
        children: [
          ClipOval(
            child: Image.asset(AppAssets.tempProfileImg),
          ),
          Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 24.h,
                width: 24.h,
                child: CircleAvatar(
                  backgroundColor: AppColors.white,
                  child: SvgPicture.asset(
                    AppAssets.closeSvg,
                    color: AppColors.black,
                    height: 14.h,
                    width: 14.h,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
