import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/controller/create_post_controller.dart';
import 'package:vip_connect/controller/post_controller.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/model/post_model.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/components/common_Icon_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/shimmer_widget.dart';

import '../../../services/firebase_auth.dart';
import '../../components/custom_post.dart';

class ArenaScreen extends StatefulWidget {
  ArenaScreen({Key? key}) : super(key: key);

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  final postController = Get.put(PostController());
  final createPostController = Get.put(CreatePostController());
  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots();
  final _postQuery = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .withConverter(
        fromFirestore: (snapshot, _) => PostModel.fromJson(snapshot.data()!),
        toFirestore: (postModel, _) => postModel.toJson(),
      );

  bool sharedPostCalledLimit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      sharedPostCalledLimit = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('sharedPostCalledLimit: $sharedPostCalledLimit');
    final signUpNotifier =
        Provider.of<SignUpUserInfoController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(
          title: "The Arena",
          // title: createPostController.postsModel.length.toString() ?? '',
          hideBackButton: true,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60.h),
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 2.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Search text field
                        Expanded(
                          child: CustomTextField(
                            mainTitle: "Search connections, channels",
                            hideMainTitle: true,
                            hintText: "Search connections, channels",
                            hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                                color: AppColors.white500, fontSize: 12),
                            filled: true,
                            fillColor: AppColors.primary,
                            prefixWidget: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: SvgPicture.asset(
                                AppAssets.maskGroup2Svg,
                                color: AppColors.secondary,
                                height: 20.h,
                                width: 20.h,
                              ),
                            ),
                            onSaved: (String? newValue) {},
                            validator: (String? value) {},
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),

                        /// Notification button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: CommonIconButton(
                            height: 53.h,
                            width: 50.w,
                            svgData: AppAssets.bellSvg,
                            isFill: true,
                            iconColor: AppColors.red,
                            onPressed: () {
                              // Get.toNamed(routeNotificationScreen);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.secondary,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FirestoreListView<PostModel>(
            query: _postQuery,
            pageSize: 200,
            cacheExtent: 1.1,
            itemBuilder:
                (BuildContext context, QueryDocumentSnapshot<dynamic> doc) {
              /// data is now typed
              PostModel postModel = doc.data();

              /// it will find the difference between post created time and date time now
              final jiffyTime = Jiffy(postModel.createdAt!.toDate()).fromNow();

              /// Manipulate the string to show LinkedIn type dateTime in post
              String jiffyStringMani = jiffyTime
                  .toString()
                  .replaceAll(' hours ago', 'h')
                  .replaceAll(' days ago', 'd')
                  .replaceAll('a day ago', '1d')
                  .replaceAll(' minutes ago', 'm')
                  .replaceAll('a few seconds ago', '0m')
                  .replaceAll('a minute ago', '1m')
                  .replaceAll('an hour ago', '1h');
              return Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: sharedPostCalledLimit == true
                      ? CustomPost(
                          postModel: postModel,
                          // index: index,
                          createdTime: jiffyStringMani,
                          isSharePost: false,
                          hideBelowImage: false,

                          /// Like: onTap
                          onTapLiked: () {
                            String currentUserUID = AuthServices().user!.uid;
                            createPostController.updateLikesFieldController(
                                postModel.id!, currentUserUID);
                          },

                          /// DisLike: onTap
                          onTapDisLiked: () {
                            String currentUserUID = AuthServices().user!.uid;
                            createPostController.updateDislikesFieldController(
                                postModel.id!, currentUserUID);
                          },

                          /// Comment: onTap
                          onTapComment: () {
                            Get.toNamed(routeCommentPost, arguments: [
                              postModel,
                              UserModel(),
                              jiffyStringMani
                            ]);
                          },

                          /// Share: onTap
                          // onTapShare: () {
                          //   Get.toNamed(routeSharePost, arguments: [
                          //     postModel,
                          //     UserModel(),
                          //     jiffyStringMani
                          //   ]);
                          // },
                        )
                      // : const Center(
                      //     child: CupertinoActivityIndicator(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // : ListView.builder(
                      //     itemCount: 5,
                      //     itemBuilder: (context, index) {
                      //       return buildShimmerWidget();
                      //     },
                      //   ));
                      : buildShimmerWidget());

              /// used for shimmer effect
            },
            loadingBuilder: (context) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, object, stackTrace) {
              return const Center(
                child: Text(
                  'Something went wrong...',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  getSharedPostData(PostModel postModel) async {
    /// Create a reference to the cities collection
    CollectionReference postRef =
        FirebaseFirestore.instance.collection("posts");

    /// Get user for post
    DocumentSnapshot? docSnapshot =
        await postRef.doc(postModel.sharePostId).get();
    PostModel repostedModel =
        PostModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
    // repostedPostedModel = repostedModel;
    return repostedModel;
  }

  /// Build Shimmer
  Widget buildShimmerWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: 1),
            borderRadius: BorderRadius.circular(08)),
        padding: EdgeInsets.all(08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerWidget.circular(width: 64, height: 64),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// User name
                    ShimmerWidget.rectangular(
                      height: 16.h,
                      width: 200.w,
                    ),
                    SizedBox(
                      height: 08.h,
                    ),

                    /// User designation
                    ShimmerWidget.rectangular(
                      height: 14.h,
                      width: 150.w,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),

            /// post description
            ShimmerWidget.rectangular(
              height: 40.h,
              width: double.infinity,
            ),
            const SizedBox(
              height: 12,
            ),

            /// post image
            ShimmerWidget.rectangular(
              height: 200.h,
              width: double.infinity,
            ),
            const SizedBox(
              height: 12,
            ),

            /// Likes texts
            ShimmerWidget.rectangular(
              height: 50.h,
              width: double.infinity,
            ),
            const SizedBox(
              height: 08,
            ),

            /// Likes buttons
            ShimmerWidget.rectangular(
              height: 50.h,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
