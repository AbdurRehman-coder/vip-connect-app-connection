import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/model/post_model.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/services/firebase_auth.dart';

import '../../constants.dart';
import '../../controller/create_post_controller.dart';
import '../../controller/post_controller.dart';
import '../../helper/app_assets.dart';
import '../../helper/app_text_styles.dart';
import '../components/custom_comment_widget.dart';
import '../components/custom_post.dart';
import '../components/spacer.dart';

class CommentPostScreen extends StatefulWidget {
  CommentPostScreen({Key? key}) : super(key: key);

  @override
  State<CommentPostScreen> createState() => _CommentPostScreenState();
}

class _CommentPostScreenState extends State<CommentPostScreen> {
  dynamic argumentsData = Get.arguments;
  TextEditingController _commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  User currentUser = AuthServices().user!;

  /// Getting controller from getX
  final PostController postController = Get.find();
  final CreatePostController createPostController = Get.find();
  UserModel? userrModel;
  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  /// Get current user who will use this app and will show it before comment text field
  Future getUserData() async {
    /// Get sing user for posts
    final CollectionReference _userCollectionRef =
        FirebaseFirestore.instance.collection('user');

    /// Get user for post
    DocumentSnapshot? docSnapshot =
        await _userCollectionRef.doc(currentUser.uid).get();
    UserModel user =
        UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

    if (mounted) {
      setState(() {
        userrModel = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    PostModel postModel = argumentsData[0];
    UserModel userModel = argumentsData[1];
    String jiffyStringMani = argumentsData[2];
    String userUID = AuthServices().user!.uid;

    return Scaffold(
      appBar: customAppBar(title: "Comments"),
      backgroundColor: AppColors.secondary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // VerticalSpacer(height: 40.h),
          /// Post Showing that we comment on
          Expanded(
            child: ListView(children: [
              CustomPost(
                postModel: postModel,

                createdTime: jiffyStringMani,
                isSharePost: false,

                /// Like: onTap
                onTapLiked: () {
                  // postController.setLiked(index);
                  // String currentUserUID = AuthServices().user!.uid;
                  // createPostController.updateLikesFieldController(
                  //     listPostsModel[index].id!, currentUserUID);
                },

                /// DisLike: onTap
                onTapDisLiked: () {
                  // postController.setDisLiked(index);
                  // String currentUserUID = AuthServices().user!.uid;
                  // createPostController
                  //     .updateDislikesFieldController(
                  //     listPostsModel[index].id!,
                  //     currentUserUID);
                },

                /// Comment: onTap
                onTapComment: () {
                  // Get.toNamed(routeCommentPost,
                  //     arguments: listPostsModel[index]);
                },

                /// Share: onTap
                onTapShare: () {
                  // Get.toNamed(routeSharePost);
                },
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('id', isEqualTo: postModel.id)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading...");
                    }

                    /// converting firestore snapshot data into models
                    List<Comments> listCommentModel = [];
                    // List<UserModel> commentUserModel = [];

                    /// firstore snapshot data
                    snapshot.data?.docs
                        .forEach((DocumentSnapshot documentSnap) async {
                      List<dynamic> firestoreComments =
                          documentSnap.get('comments');
                      listCommentModel.clear();
                      firestoreComments.forEach((singleComment) {
                        Comments commentModel = Comments.fromJson(
                            singleComment as Map<String, dynamic>);

                        /// adding comment model into listOfComments
                        listCommentModel.add(commentModel);
                      });
                    });

                    if (listCommentModel.isNotEmpty) {
                      createPostController.clearCommentUserModel();
                      for (var commentM in listCommentModel) {
                        /// Get sing user for posts
                        final CollectionReference _userCollectionRef =
                            FirebaseFirestore.instance.collection('user');

                        /// Get user for post
                        _userCollectionRef
                            .doc(commentM.uid)
                            .get()
                            .then((userDoc) {
                          print('userDoc:::: ${userDoc.data()}');
                          if (userDoc.data() != null) {
                            UserModel commentUser = UserModel.fromJson(
                                userDoc.data() as Map<String, dynamic>);
                            createPostController
                                .setCommentUserModel(commentUser);
                          }
                        });
                      }
                    }
                    return listCommentModel.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            reverse: true,
                            itemCount: listCommentModel.length,
                            itemBuilder: (context, index) {
                              /// it will find the difference between post created time and date time now
                              final jiffyTime = Jiffy(listCommentModel[index]
                                      .createdAt!
                                      .toDate())
                                  .fromNow();

                              /// Manipulate the string to show LinkedIn type dateTime in post
                              String jiffyStringMani = jiffyTime
                                  .toString()
                                  .replaceAll('hours ago', 'h')
                                  .replaceAll('days ago', 'd')
                                  .replaceAll('a day ago', '1 d')
                                  .replaceAll('minutes ago', 'm')
                                  .replaceAll('a few seconds ago', '0 m')
                                  .replaceAll('a minute ago', '1 m')
                                  .replaceAll('an hour ago', '1 h')
                                  .replaceAll('in a few seconds', '0 m');

                              return CustomCommentWidget(
                                commentModel: listCommentModel[index],
                                jiffyTimeString: jiffyStringMani,
                              );
                            })
                        : const Padding(
                            padding: EdgeInsets.only(top: 40.0),
                            child: Center(
                              child: Text(
                                'No Comments',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                  })
            ]),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5),
            child: Form(
              key: formKey,
              child: Row(
                children: [
                  SizedBox(
                    height: 42.h,
                    width: 42.h,
                    child: CircleAvatar(
                      /// User  picture inside post
                      child: userrModel?.profileImage != null
                          ? CachedNetworkImage(
                              imageUrl: userrModel!.profileImage.toString(),
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
                                AppAssets.logoImg,
                              ),
                            )
                          : Image.asset(
                              AppAssets.logoImg,
                            ),
                    ),
                  ),
                  HorizontalSpacer(width: 6.w),

                  /// Message TextField
                  Expanded(
                    child: Container(
                      height: 94.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black800,
                        borderRadius: BorderRadius.circular(kBorderRadius16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 17.w, vertical: 23.h),
                        child: TextFormField(
                          controller: _commentController,
                          maxLines: 1,
                          validator: (value) {
                            if (value!.length < 2) {
                              return 'Please enter valid date';
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            fillColor: AppColors.primary,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            hintStyle: AppTextStyle.bodyRegular.copyWith(
                              fontSize: kFontSize12,
                              color: AppColors.hintText,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            contentPadding: EdgeInsets.zero,
                            hintText: '  Add a comment',
                            suffixIcon: Container(
                              color: Colors.grey.shade200,
                              child: InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    Comments comment = Comments(
                                      uid: userUID,
                                      commentMessage:
                                          _commentController.text.toString(),
                                      createdAt: Timestamp.now(),
                                    );
                                    createPostController
                                        .updateCommentFieldController(
                                            postModel.id!, comment);
                                    _commentController.clear();

                                    /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                                    /// next screen
                                    FocusScope.of(context).unfocus();
                                  } else {}
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     Util.showAttachmentBottomSheet();
                                    //   },
                                    //   child: SvgPicture.asset(
                                    //     AppAssets.attachmentSvg,
                                    //     color: AppColors.icons1,
                                    //     height: 18.h,
                                    //     width: 14.w,
                                    //   ),
                                    // ),
                                    // HorizontalSpacer(width: 10.w),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     print("Tapped");
                                    //   },
                                    //   child: SvgPicture.asset(
                                    //     AppAssets.imageSvg,
                                    //     color: AppColors.icons1,
                                    //     height: 18.h,
                                    //     width: 10.w,
                                    //   ),
                                    // ),
                                    // HorizontalSpacer(width: 10.w),
                                    SvgPicture.asset(
                                      AppAssets.sendSvg,
                                      color: AppColors.icons1,
                                      height: 14.h,
                                      width: 18.w,
                                    ),
                                    // HorizontalSpacer(width: 20.w),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
