import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
// import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
// import 'linearPercentComponent.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/model/post_model.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/components/common_Icon_and_text_button.dart'; //
import 'package:vip_connect/screens/components/share_custom_post.dart';
import 'package:vip_connect/screens/components/shimmer_widget.dart';
import 'package:vip_connect/screens/components/spacer.dart';
import 'package:vip_connect/screens/post/post_edit_screen.dart';
import 'package:vip_connect/services/create_post_firestore.dart';
import 'package:vip_connect/services/firebase_auth.dart';

import '../../config/routes.dart';
import '../../controller/create_post_controller.dart';
import '../../controller/post_controller.dart';
import '../../helper/app_texts.dart';
import 'common_button.dart';

class CustomPost extends StatefulWidget {
  CustomPost({
    Key? key,
    this.hideBelowImage,
    this.postModel,
    this.repostedPostedModel,
    // this.userModel,
    this.index,
    this.createdTime,
    this.isSharePost,
    required this.onTapLiked,
    required this.onTapDisLiked,
    required this.onTapComment,
    this.onTapShare,
  }) : super(key: key);

  PostModel? postModel;
  PostModel? repostedPostedModel;
  // UserModel? userModel;
  bool? hideBelowImage;
  bool? isSharePost;
  VoidCallback? onTapLiked, onTapDisLiked, onTapComment, onTapShare;
  int? index;
  String? createdTime;

  @override
  State<CustomPost> createState() => _CustomPostState();
}

class _CustomPostState extends State<CustomPost> {
  final PostController postController = Get.find();
  final CreatePostController createPostController = Get.find();
  UserModel? userrModel;
  User? currentUser = AuthServices().user;
  bool isVoted = false;
  bool forDelay = false;
  int optionNumber = 0;
  final _containerKey = GlobalKey();
  Uint8List? _documentBytes;
  double? imageDownloadProgress;

  // /// Video player controller
  // VideoPlayerController? _videoController;

  bool sharePostCalled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPostUser(widget.postModel!.uid.toString())
    //     .then((value) => print('user modellllll: $value'));
    final signupNotifier =
        Provider.of<SignUpUserInfoController>(context, listen: false);
    getUserData();

    if (widget.postModel!.postType == "videoPost") {
      signupNotifier.videoController = VideoPlayerController.network(
        widget.postModel!.postImage.toString(),
      )
        ..initialize().then((_) {
          // _videoController?.play();
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          if (mounted) {
            setState(() {});
          }
        })
        ..setLooping(true);
    }
    if (widget.postModel?.postType == 'sharePost') {
      getRepostedPostInfo();
    }
  }

  PostModel? repostedPostedModel;
  getRepostedPostInfo() async {
    if (mounted) {
      setState(() => sharePostCalled = true);
    }

    /// Get sing user for posts
    final CollectionReference posts =
        FirebaseFirestore.instance.collection('posts');

    /// Get user for post
    DocumentSnapshot? docSnapshot =
        await posts.doc(widget.postModel?.sharePostId).get();
    if (docSnapshot.data() != null) {
      PostModel repostedModel =
          PostModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

      repostedPostedModel = repostedModel;
    }
    if (mounted) {
      setState(() => sharePostCalled = false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('arena dispose method called...customscreen');
    // SignUpUserInfoController signUpUserInfoController =
    //     Provider.of<SignUpUserInfoController>(context, listen: false);
    // if (signUpUserInfoController.videoController!.value.isInitialized) {
    //   signUpUserInfoController.videoController?.pause();
    //   signUpUserInfoController.videoController?.dispose();
    // }
    // Provider.of<SignUpUserInfoController>(context, listen: false)
    //     .videoController
    //     ?.pause();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('arena dispose method called...custom didDependency');
  }

  Future getUserData() async {
    /// Get sing user for posts
    final CollectionReference _userCollectionRef =
        FirebaseFirestore.instance.collection('user');

    /// Get user for post
    DocumentSnapshot? docSnapshot =
        await _userCollectionRef.doc(widget.postModel?.uid).get();
    print('user for psot>..${docSnapshot.data()}');
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
    SignUpUserInfoController signupNotifier =
        Provider.of<SignUpUserInfoController>(
      context,
    );
    print(
        'resposted share model... ${widget.postModel?.shares?.length.toString()}');
    User? user = AuthServices().user;
    // int totalVotes = 0;
    // if (widget.postModel?.options != null) {
    //   widget.postModel?.options?.forEach((element) {
    //     if (element.votes != null) {
    //       totalVotes += element.votes!;
    //     }
    //   });
    // }
    /// TODO: Poll expiration
    // String pollJiffyStringMani = '';
    // if (widget.postModel?.pollExpireDate != null) {
    //   /// it will find the difference between post created time and date time now
    //   final jiffyTime = Jiffy(widget.postModel?.pollExpireDate!).fromNow();
    //
    //   /// Manipulate the string to show LinkedIn type dateTime in post
    //   pollJiffyStringMani = jiffyTime
    //       .toString()
    //       .replaceAll(' hours ago', 'h')
    //       .replaceAll(' days ago', 'd')
    //       .replaceAll('a day ago', '1 d')
    //       .replaceAll(' minutes ago', 'm')
    //       .replaceAll('a few seconds ago', '0 m')
    //       .replaceAll('a minute ago', '1 m')
    //       .replaceAll('an hour ago', '1 h')
    //       .replaceAll('in 24 hours', '1d')
    //       .replaceAll('in 3 days', '3d')
    //       .replaceAll('in 7 days', '1w')
    //       .replaceAll('in 14 days', '2w')
    //       .replaceAll('an hour ago', '1 h');
    //
    //   /// it will check if the createdTime of poll is after the expirationTime so
    //   /// it means the poll is expired and we have to delete it
    //   var isPollExpire =
    //       Jiffy(DateTime.now()).isAfter(widget.postModel?.pollExpireDate);
    //
    //   if (isPollExpire) {
    //     PostsFirestoreDatebase()
    //         .deletePostFromArenaScreen(widget.postModel!.id!);
    //   }
    // }

    // print('counting votes:: ${totalVotes}');
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 8.w,
            right: 8.w,
            top: 9.h,
            bottom: (widget.hideBelowImage == null ||
                    widget.hideBelowImage == false)
                ? 9.h
                : 0),
        decoration: BoxDecoration(
          color: AppColors.black800,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(kBorderRadius20),
              bottom: (widget.hideBelowImage == null ||
                      widget.hideBelowImage == false)
                  ? Radius.circular(kBorderRadius20)
                  : const Radius.circular(0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.postModel?.postType == 'sharePost'
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// User Profile
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                // Get.toNamed(routeShowPostUserProfile,
                                //     arguments: [userrModel?.uid.toString()]);

                                /// go to user detail screen [vip detail]
                                Get.toNamed(
                                  routeVipDetailScreen,
                                  arguments: [
                                    userrModel?.uid.toString(),
                                    'none'
                                  ],
                                );
                              },
                              child: SizedBox(
                                height: 35.h,
                                width: 35.h,
                                child: CircleAvatar(
                                  /// User  picture inside post
                                  child: userrModel?.profileImage != null
                                      ? CachedNetworkImage(
                                          imageUrl: userrModel!.profileImage
                                              .toString(),
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                            AppAssets.logoImg,
                                          ),
                                        )
                                      : Image.asset(
                                          AppAssets.logoImg,
                                        ),
                                ),
                              ),
                            ),
                            HorizontalSpacer(width: 10.w),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// User name
                                  Text(
                                    userrModel?.firstName != null
                                        ? '${userrModel?.firstName} ${userrModel?.lastName}'
                                        : "Jonathan Cooper",
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      fontSize: kFontSize11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      /// Designation text
                                      Text(
                                        userrModel?.jobTitle != null
                                            ? '${userrModel?.jobTitle}'
                                            : " ",
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          fontSize: kFontSize8,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),

                                      /// Company name
                                      Text(
                                        userrModel?.employerName != null
                                            ? ' @ ${userrModel?.employerName}'
                                            : " ",
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          fontSize: kFontSize8,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalSpacer(height: 3.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// DateTime
                                      Text(
                                        widget.createdTime.toString(),
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          fontSize: kFontSize12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      HorizontalSpacer(width: 5.w),
                                      widget.postModel?.postAddress != null
                                          ? Text(
                                              widget.postModel!.postAddress
                                                  .toString(),
                                              style: AppTextStyle.bodyMedium
                                                  .copyWith(
                                                fontSize: kFontSize12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Container(),
                                      // SvgPicture.asset(
                                      //   AppAssets.worldSvg,
                                      //   color: AppColors.primary,
                                      //   height: 12.h,
                                      //   width: 12.w,
                                      // )
                                    ],
                                  )
                                ],
                              ),
                            ),

                            /// Post Pop Menu Button options [edit, delete]
                            currentUser?.uid == widget.postModel?.uid
                                ? PopupMenuButton(
                                    color: AppColors.border,
                                    icon: SvgPicture.asset(
                                        AppAssets.moreVerticalSvg),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: 0,
                                          child: Text(
                                            AppTexts.edit,
                                            style: AppTextStyle.popping14_600,
                                          ),
                                          onTap: () {
                                            Future.delayed(Duration(seconds: 1),
                                                () {
                                              editPost(widget.postModel!);
                                            });
                                          },
                                        ),
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text(
                                            AppTexts.delete,
                                            style: AppTextStyle.popping14_600,
                                          ),
                                          onTap: () {
                                            if (widget.postModel?.postType !=
                                                'poll') {
                                              if (currentUser?.uid ==
                                                  widget.postModel?.uid) {
                                                PostsFirestoreDatebase()
                                                    .deletePostFromArenaScreen(
                                                        widget.postModel!.id!);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Only owner can delete",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.white,
                                                    backgroundColor: Colors.red,
                                                    fontSize: 16.0);
                                                // Get.snackbar(
                                                //   '',
                                                //   'Only owner can delete the post',
                                                //   colorText: Colors.white,
                                                //   backgroundColor: AppColors.red,
                                                //   snackPosition: SnackPosition.TOP,
                                                //   snackStyle: SnackStyle.FLOATING,
                                                //   padding: EdgeInsets.only(
                                                //       left: 08,
                                                //       right: 08,
                                                //       bottom: 10),
                                                //
                                                //   // icon: const Icon(Icons.add_alert),
                                                // );
                                              }
                                            } else {
                                              Get.snackbar(
                                                'Poll deleted itself after expiration',
                                                '',
                                                colorText: Colors.white,
                                                backgroundColor: AppColors.red,
                                                snackPosition:
                                                    SnackPosition.TOP,

                                                // icon: const Icon(Icons.add_alert),
                                              );
                                            }
                                          },
                                        ),
                                      ];
                                    },
                                    onSelected: (value) {},
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ReadMoreText(
                          widget.postModel?.postDescription != null
                              ? widget.postModel!.postDescription.toString()
                              : 'dummy description',
                          style: AppTextStyle.bodyRegular.copyWith(
                            fontSize: kFontSize11,
                            color: AppColors.primary,
                          ),
                          trimLines: 2,
                          colorClickableText: Colors.white38,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: '  Show less',
                          moreStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white38),
                          lessStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white38),
                        ),
                        SizedBox(
                          height: 50,
                        ),

                        /// ShareCustom Post
                        sharePostCalled == true
                            ? buildShimmerWidgetSharePost()
                            : repostedPostedModel != null
                                ? ShareCustomPost(
                                    postModel: repostedPostedModel,
                                    originalPostId: widget.postModel?.id,
                                    originalPostModel: widget.postModel,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.black800,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(4),
                                          bottom:
                                              (widget.hideBelowImage == null ||
                                                      widget.hideBelowImage ==
                                                          false)
                                                  ? Radius.circular(4)
                                                  : const Radius.circular(0)),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 15),
                                      child: Text(
                                        'content is not available',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ),
                        // : Center(
                        //     child: CupertinoActivityIndicator(
                        //       color: Colors.white,
                        //     ),
                        //   ),

                        /// SharePost Show Likes, Dislikes & Comments
                        if (true) ...{
                          VerticalSpacer(height: 12.h),
                          Row(
                            children: [
                              // Text(
                              //   "12.K Likes  120 Comments  600 Shares",
                              //   style: AppTextStyle.bodyRegular.copyWith(
                              //     fontSize: kFontSize12,
                              //     color: AppColors.white300,
                              //   ),
                              // ),
                              /// likes
                              Text(
                                "${widget.postModel?.likes?.length.toString()} Likes",
                                style: AppTextStyle.bodyRegular.copyWith(
                                  fontSize: kFontSize12,
                                  color: AppColors.white300,
                                ),
                              ),

                              /// Dislikes
                              Text(
                                " ${widget.postModel?.dislikes?.length.toString()} Dislike",
                                style: AppTextStyle.bodyRegular.copyWith(
                                  fontSize: kFontSize12,
                                  color: AppColors.white300,
                                ),
                              ),
                              Text(
                                " ${widget.postModel?.comments?.length.toString()} Comments",
                                style: AppTextStyle.bodyRegular.copyWith(
                                  fontSize: kFontSize12,
                                  color: AppColors.white300,
                                ),
                              ),
                              Text(
                                " Shares",
                                style: AppTextStyle.bodyRegular.copyWith(
                                  fontSize: kFontSize12,
                                  color: AppColors.white300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Liked Button
                                CommonIconAndTextButton(
                                  height: 22.h,
                                  text: widget.postModel!.likes!
                                          .contains(AuthServices().user?.uid)
                                      ? 'Liked'
                                      : 'Like',
                                  iconSize16: true,
                                  svgData: AppAssets.maskGroupSvg,
                                  isFill: true,
                                  iconColor: widget.postModel!.likes!
                                          .contains(AuthServices().user?.uid)
                                      ? Colors.blueAccent
                                      : AppColors.secondary,
                                  onPressed: widget.onTapLiked!,
                                ),
                                SizedBox(width: 15.w),

                                /// DisLiked Button
                                CommonIconAndTextButton(
                                  height: 22.h,
                                  text: widget.postModel!.dislikes!
                                          .contains(AuthServices().user?.uid)
                                      ? 'Disliked'
                                      : 'Dislike',
                                  iconSize16: true,
                                  svgData: AppAssets.maskGroup1Svg,
                                  isFill: true,
                                  iconColor: widget.postModel!.dislikes!
                                          .contains(AuthServices().user?.uid)
                                      ? Colors.redAccent
                                      : AppColors.secondary,
                                  onPressed: widget.onTapDisLiked!,
                                ),
                                SizedBox(width: 15.w),
                                CommonIconAndTextButton(
                                  height: 22.h,
                                  text: 'Comment',
                                  iconSize16: false,
                                  svgData: AppAssets.messageSquareSvg,
                                  isFill: true,
                                  iconColor: AppColors.secondary,
                                  onPressed: widget.onTapComment!,
                                ),
                                SizedBox(width: 15.w),

                                /// SharePost Share button
                                CommonIconAndTextButton(
                                  height: 22.h,
                                  text: 'Share',
                                  iconSize16: false,
                                  svgData: AppAssets.shareSvg,
                                  isFill: true,
                                  iconColor: AppColors.secondary,
                                  onPressed: () {
                                    /// it will find the difference between post created time and date time now
                                    final jiffyTime = Jiffy(repostedPostedModel
                                            ?.createdAt!
                                            .toDate())
                                        .fromNow();

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
                                    Get.toNamed(routeSharePost, arguments: [
                                      repostedPostedModel,
                                      UserModel(),
                                      jiffyStringMani,
                                    ]);
                                  },
                                ),
                              ],
                            ),
                          ),
                          VerticalSpacer(height: 6.h),
                        }
                      ],
                    ),
                  )

                /// post type other than share post, then show this widgets
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// User Profile for other posts
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              // Get.toNamed(routeShowPostUserProfile,
                              //     arguments: [userrModel?.uid.toString()]);
                              print('arean user profile clicked');

                              /// go to user detail screen [vip detail]
                              Get.toNamed(
                                routeVipDetailScreen,
                                arguments: [userrModel?.uid.toString(), 'none'],
                              );
                            },
                            child: SizedBox(
                              height: 35.h,
                              width: 35.h,
                              child: CircleAvatar(
                                /// User  picture inside post
                                child: userrModel?.profileImage != null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            userrModel!.profileImage.toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                          AppAssets.logoImg,
                                        ),
                                      )
                                    : Image.asset(
                                        AppAssets.logoImg,
                                      ),
                              ),
                            ),
                          ),
                          HorizontalSpacer(width: 10.w),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// User name
                                Text(
                                  userrModel?.firstName != null
                                      ? '${userrModel?.firstName} ${userrModel?.lastName}'
                                      : "Jonathan Cooper",
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    fontSize: kFontSize11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Row(
                                  children: [
                                    /// Designation text
                                    Text(
                                      userrModel?.jobTitle != null
                                          ? '${userrModel?.jobTitle}'
                                          : " ",
                                      style: AppTextStyle.bodyMedium.copyWith(
                                        fontSize: kFontSize8,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),

                                    /// Company name
                                    Text(
                                      userrModel?.employerName != null
                                          ? ' @ ${userrModel?.employerName}'
                                          : " ",
                                      style: AppTextStyle.bodyMedium.copyWith(
                                        fontSize: kFontSize8,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalSpacer(height: 3.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// DateTime
                                    Text(
                                      widget.createdTime.toString(),
                                      style: AppTextStyle.bodyMedium.copyWith(
                                        fontSize: kFontSize12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    HorizontalSpacer(width: 5.w),
                                    widget.postModel?.postAddress != null
                                        ? Text(
                                            widget.postModel!.postAddress
                                                .toString(),
                                            style: AppTextStyle.bodyMedium
                                                .copyWith(
                                              fontSize: kFontSize12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        : Container(),
                                    // SvgPicture.asset(
                                    //   AppAssets.worldSvg,
                                    //   color: AppColors.primary,
                                    //   height: 12.h,
                                    //   width: 12.w,
                                    // )
                                  ],
                                )
                              ],
                            ),
                          ),

                          /// Post Pop Menu Button options [edit, delete]
                          currentUser?.uid == widget.postModel?.uid
                              ? PopupMenuButton(
                                  color: AppColors.border,
                                  icon: SvgPicture.asset(
                                      AppAssets.moreVerticalSvg),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 0,
                                        child: Text(
                                          AppTexts.edit,
                                          style: AppTextStyle.popping14_600,
                                        ),
                                        onTap: () {
                                          print('edit button tapped');
                                          // Navigator.pop(context);

                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            editPost(widget.postModel!);
                                          });
                                        },
                                      ),
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          AppTexts.delete,
                                          style: AppTextStyle.popping14_600,
                                        ),
                                        onTap: () {
                                          if (widget.postModel?.postType !=
                                              'poll') {
                                            if (currentUser?.uid ==
                                                widget.postModel?.uid) {
                                              PostsFirestoreDatebase()
                                                  .deletePostFromArenaScreen(
                                                      widget.postModel!.id!);
                                            } else {
                                              Get.snackbar(
                                                'Only owner can delete the post',
                                                '',
                                                colorText: Colors.white,
                                                backgroundColor: AppColors.red,
                                                snackPosition:
                                                    SnackPosition.TOP,

                                                // icon: const Icon(Icons.add_alert),
                                              );
                                            }
                                          } else {
                                            Get.snackbar(
                                              'Poll deleted itself after expiration',
                                              '',
                                              colorText: Colors.white,
                                              backgroundColor: AppColors.red,
                                              snackPosition: SnackPosition.TOP,

                                              // icon: const Icon(Icons.add_alert),
                                            );
                                          }
                                        },
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {},
                                )
                              : Container(),
                        ],
                      ),
                      VerticalSpacer(height: 12.h),

                      /// Post Headline
                      widget.postModel?.postType == 'articlePost'
                          ? Text(
                              widget.postModel!.articleHeadline.toString(),
                              style: AppTextStyle.bodyRegular.copyWith(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            )
                          : Container(),

                      SizedBox(
                        height: 10.h,
                      ),

                      /// Post Description
                      widget.postModel?.postType == 'poll'
                          ? Container(
                              child: Text(''),
                            )
                          : ReadMoreText(
                              widget.postModel?.postDescription != null
                                  ? widget.postModel!.postDescription.toString()
                                  : 'dummy description',
                              style: AppTextStyle.bodyRegular.copyWith(
                                fontSize: kFontSize11,
                                color: AppColors.primary,
                              ),
                              trimLines: 2,
                              colorClickableText: Colors.white38,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white38),
                              lessStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white38),
                            ),

                      widget.postModel?.postType == 'poll'
                          ? Container()
                          : VerticalSpacer(height: 16.h),

                      (widget.postModel!.postType == "imagePost" ||
                              widget.postModel!.postType == "articlePost")
                          // ? Image.network(
                          //     widget.postModel!.postImage.toString(),
                          //     fit: BoxFit.fitHeight,
                          //     // height: 200,
                          //     width: double.infinity,
                          //     loadingBuilder: (BuildContext context,
                          //         Widget child,
                          //         ImageChunkEvent? loadingProgress) {
                          //       if (loadingProgress == null) return child;
                          //       return Center(
                          //         child: CircularProgressIndicator(
                          //           value: loadingProgress.expectedTotalBytes !=
                          //                   null
                          //               ? loadingProgress
                          //                       .cumulativeBytesLoaded /
                          //                   loadingProgress.expectedTotalBytes!
                          //               : null,
                          //         ),
                          //       );
                          //     },
                          //     errorBuilder: (context, exception, stackTrace) {
                          //       return Image.asset(
                          //         AppAssets.dummyPostImg,
                          //         fit: BoxFit.cover,
                          //         height: (widget.hideBelowImage == null ||
                          //                 widget.hideBelowImage == false)
                          //             ? 170.h
                          //             : 130.h,
                          //         width: double.infinity,
                          //       );
                          //     },
                          //   )
                          /// post image
                          ? CachedNetworkImage(
                              imageUrl: widget.postModel!.postImage.toString(),
                              fit: BoxFit.fitHeight,
                              // height: 200,
                              width: double.infinity,
                              progressIndicatorBuilder:
                                  (BuildContext context, string, progress) {
                                // if (preg == null) return child;
                                return Center(
                                  child: CupertinoActivityIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              },
                              errorWidget: (context, exception, stackTrace) {
                                return Container(
                                  height: 15,
                                );
                                // return Image.asset(
                                //   AppAssets.dummyPostImg,
                                //   fit: BoxFit.cover,
                                //   height: (widget.hideBelowImage == null ||
                                //           widget.hideBelowImage == false)
                                //       ? 170.h
                                //       : 130.h,
                                //   width: double.infinity,
                                // );
                              },
                            )
                          : widget.postModel!.postType == "DocPost"

                              /// Document Post
                              ? Container(
                                  height: widget.postModel!.fileType == 'pdf'
                                      ? 290.h
                                      : 45.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(08),
                                    color: AppColors.disableButton,
                                  ),
                                  child: widget.postModel?.postImage != null
                                      ? widget.postModel!.fileType == 'pdf'
                                          ? Container(
                                              child: SfPdfViewer.network(
                                                widget.postModel!.postImage!,
                                                // _documentBytes!,
                                                scrollDirection:
                                                    PdfScrollDirection
                                                        .horizontal,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                openFile(
                                                  url: widget
                                                      .postModel!.postImage
                                                      .toString(),
                                                  fileName: 'VipConnectFile',
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  const Icon(
                                                      Icons
                                                          .file_present_outlined,
                                                      color: Colors.blueAccent),
                                                  SizedBox(
                                                    width: 12.w,
                                                  ),
                                                  const Text(
                                                    'vip_document_file.',
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.postModel!.fileType
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const Icon(
                                                      Icons.open_in_new_rounded,
                                                      color: Colors.blueAccent),
                                                ],
                                              ),
                                            )
                                      : const Center(
                                          child: CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        )

                                  ///TODO: PdfViewer asset is working fine
                                  // ? SfPdfViewer.asset(
                                  //     // widget.postModel!.postImage!,
                                  //     'assets/files/Python-Cheat-Sheet.pdf',
                                  //     scrollDirection: PdfScrollDirection.horizontal,
                                  //   )

                                  ///TODO: This will be uncommenting for file of type images
                                  // child: Image.network(
                                  //   widget.postModel!.postImage.toString(),
                                  //   fit: BoxFit.fitHeight,
                                  //   height: 200,
                                  //   width: double.infinity,
                                  //   loadingBuilder: (BuildContext context, Widget child,
                                  //       ImageChunkEvent? loadingProgress) {
                                  //     if (loadingProgress == null) return child;
                                  //     return Center(
                                  //       child: CircularProgressIndicator(
                                  //         value: loadingProgress.expectedTotalBytes != null
                                  //             ? loadingProgress.cumulativeBytesLoaded /
                                  //                 loadingProgress.expectedTotalBytes!
                                  //             : null,
                                  //       ),
                                  //     );
                                  //   },
                                  //   errorBuilder: (context, exception, stackTrace) {
                                  //     return Image.asset(
                                  //       AppAssets.dummyPostImg,
                                  //       fit: BoxFit.cover,
                                  //       height: (widget.hideBelowImage == null ||
                                  //               widget.hideBelowImage == false)
                                  //           ? 170.h
                                  //           : 130.h,
                                  //       width: double.infinity,
                                  //     );
                                  //   },
                                  // ),

                                  // : Center(
                                  //     child: Column(
                                  //       children: const [
                                  //         CircularProgressIndicator(
                                  //           color: Colors.white,
                                  //         ),
                                  //         Text(
                                  //           'file loading...',
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 14,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  )
                              : widget.postModel!.postType == "videoPost"

                                  /// Video Post
                                  ? Container(
                                      child: signupNotifier.videoController !=
                                                  null &&
                                              signupNotifier.videoController!
                                                  .value.isInitialized
                                          ? AspectRatio(
                                              aspectRatio: signupNotifier
                                                      .videoController!
                                                      .value
                                                      .aspectRatio /
                                                  0.8,
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                children: <Widget>[
                                                  VideoPlayer(signupNotifier
                                                      .videoController!),
                                                  ClosedCaption(
                                                      text: signupNotifier
                                                          .videoController
                                                          ?.value
                                                          .caption
                                                          .text),
                                                  _ControlsOverlay(context),
                                                  // VideoOverlayControllers(
                                                  //     controller: _controller!),
                                                  VideoProgressIndicator(
                                                      signupNotifier
                                                          .videoController!,
                                                      allowScrubbing: true),
                                                ],
                                              ),
                                            )
                                          : buildShimmerWidget()
                                      // : Center(
                                      //     child: CupertinoActivityIndicator(
                                      //       color: Colors.white,
                                      //     ),
                                      //   ),
                                      )
                                  : widget.postModel!.postType == "poll"
                                      ? PollCustomWidget(
                                          postModel: widget.postModel,
                                        )
                                      : Container(
                                          child: const Text(
                                            'Post type is not specified',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ),

                      if (widget.isSharePost == false) ...{
                        VerticalSpacer(height: 12.h),
                        Row(
                          children: [
                            // Text(
                            //   "12.K Likes  120 Comments  600 Shares",
                            //   style: AppTextStyle.bodyRegular.copyWith(
                            //     fontSize: kFontSize12,
                            //     color: AppColors.white300,
                            //   ),
                            // ),
                            /// likes
                            Text(
                              "${widget.postModel?.likes?.length.toString()} Likes",
                              style: AppTextStyle.bodyRegular.copyWith(
                                fontSize: kFontSize12,
                                color: AppColors.white300,
                              ),
                            ),

                            /// Dislikes
                            Text(
                              " ${widget.postModel?.dislikes?.length.toString()} Dislike",
                              style: AppTextStyle.bodyRegular.copyWith(
                                fontSize: kFontSize12,
                                color: AppColors.white300,
                              ),
                            ),
                            Text(
                              " ${widget.postModel?.comments?.length.toString()} Comments",
                              style: AppTextStyle.bodyRegular.copyWith(
                                fontSize: kFontSize12,
                                color: AppColors.white300,
                              ),
                            ),
                            Text(
                              " ${widget.postModel?.sharesLength.toString()} Shares",
                              style: AppTextStyle.bodyRegular.copyWith(
                                fontSize: kFontSize12,
                                color: AppColors.white300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Liked Button
                              CommonIconAndTextButton(
                                height: 22.h,
                                text: widget.postModel!.likes!
                                        .contains(AuthServices().user?.uid)
                                    ? 'Liked'
                                    : 'Like',
                                iconSize16: true,
                                svgData: AppAssets.maskGroupSvg,
                                isFill: true,
                                iconColor: widget.postModel!.likes!
                                        .contains(AuthServices().user?.uid)
                                    ? Colors.blueAccent
                                    : AppColors.secondary,
                                onPressed: widget.onTapLiked!,
                              ),
                              SizedBox(width: 15.w),

                              /// DisLiked Button
                              CommonIconAndTextButton(
                                height: 22.h,
                                text: widget.postModel!.dislikes!
                                        .contains(AuthServices().user?.uid)
                                    ? 'Disliked'
                                    : 'Dislike',
                                iconSize16: true,
                                svgData: AppAssets.maskGroup1Svg,
                                isFill: true,
                                iconColor: widget.postModel!.dislikes!
                                        .contains(AuthServices().user?.uid)
                                    ? Colors.redAccent
                                    : AppColors.secondary,
                                onPressed: widget.onTapDisLiked!,
                              ),
                              SizedBox(width: 15.w),
                              CommonIconAndTextButton(
                                height: 22.h,
                                text: 'Comment',
                                iconSize16: false,
                                svgData: AppAssets.messageSquareSvg,
                                isFill: true,
                                iconColor: AppColors.secondary,
                                onPressed: widget.onTapComment!,
                              ),
                              SizedBox(width: 15.w),

                              /// OtherPost Share button
                              CommonIconAndTextButton(
                                height: 22.h,
                                text: 'Share',
                                iconSize16: false,
                                svgData: AppAssets.shareSvg,
                                isFill: true,
                                iconColor: AppColors.secondary,
                                onPressed: () {
                                  /// it will find the difference between post created time and date time now
                                  final jiffyTime = Jiffy(
                                          widget.postModel?.createdAt!.toDate())
                                      .fromNow();

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
                                  Get.toNamed(routeSharePost, arguments: [
                                    widget.postModel,
                                    UserModel(),
                                    jiffyStringMani,
                                  ]);
                                },
                              ),
                            ],
                          ),
                        ),
                        VerticalSpacer(height: 6.h),
                      }
                    ],
                  )
          ],
        ),
      ),
    );
  }

  /// =============== Outside Build ==================== ///
  editPost(PostModel postModel) {
    if (widget.postModel?.postType != 'poll') {
      if (currentUser?.uid == widget.postModel?.uid) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditArenaPostScreen(
                      postModel: postModel,
                    )));
      } else {
        Get.snackbar(
          'Only owner can edit the post',
          '',
          colorText: Colors.white,
          backgroundColor: AppColors.red,
          snackPosition: SnackPosition.TOP,

          // icon: const Icon(Icons.add_alert),
        );
      }
    } else {
      Get.snackbar(
        'Poll is not editable',
        '',
        colorText: Colors.white,
        backgroundColor: AppColors.red,
        snackPosition: SnackPosition.TOP,

        // icon: const Icon(Icons.add_alert),
      );
    }
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;
    print('malik johannes file path: ${file.path}');
    OpenFilex.open(file.path);
  }

  /// Download file into private folder not visible to the user
  Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/$name');

      Dio dio = Dio();
      final response = await dio.get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            // receiveTimeout: 0,
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (err) {
      print('open file and write func error: $err');
      return null;
    }
  }

  /// Video player overlay widgets class
  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  // final VideoPlayerController controller;
  _ControlsOverlay(context) {
    SignUpUserInfoController signupNotifier =
        Provider.of<SignUpUserInfoController>(context, listen: true);

    /// check if the video is mute or not
    final isMuted = signupNotifier.videoController?.value.volume == 0;
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          reverseDuration: const Duration(milliseconds: 100),
          child: signupNotifier.videoController!.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 20,
                      child: Icon(
                        signupNotifier.videoController!.value.isPlaying
                            ? Icons.stop
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 25.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            signupNotifier.videoController!.value.isPlaying
                ? signupNotifier.videoController?.pause()
                : signupNotifier.videoController?.play();
            setState(() {});
          },
        ),

        /// Caption
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: PopupMenuButton<Duration>(
        //     initialValue: _videoController?.value.captionOffset,
        //     tooltip: 'Caption Offset',
        //     onSelected: (Duration delay) {
        //       _videoController?.setCaptionOffset(delay);
        //     },
        //     itemBuilder: (BuildContext context) {
        //       return <PopupMenuItem<Duration>>[
        //         for (final Duration offsetDuration in _exampleCaptionOffsets)
        //           PopupMenuItem<Duration>(
        //             value: offsetDuration,
        //             child: Text('${offsetDuration.inMilliseconds}ms'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text(
        //           '${_videoController?.value.captionOffset.inMilliseconds}ms'),
        //     ),
        //   ),
        // ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: signupNotifier.videoController?.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              signupNotifier.videoController?.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text(
                      '${speed}x',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Container(
                  decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '${signupNotifier.videoController?.value.playbackSpeed}x',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )),
            ),
          ),
        ),

        /// mute and unMute button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(
                  isMuted ? Icons.volume_mute : Icons.volume_up,
                  color: Colors.red,
                ),
                onPressed: () {
                  signupNotifier.videoController?.setVolume(isMuted ? 1 : 0);
                  setState(() {});
                }),
          ),
        ),
      ],
    );
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
            const SizedBox(
              height: 12,
            ),

            /// post description
            // ShimmerWidget.rectangular(
            //   height: 40.h,
            //   width: double.infinity,
            // ),
            // const SizedBox(
            //   height: 12,
            // ),

            /// post image
            ShimmerWidget.rectangular(
              height: 200.h,
              width: double.infinity,
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  /// Build Shimmer
  Widget buildShimmerWidgetSharePost() {
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
                ShimmerWidget.circular(width: 44, height: 44),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// User name
                    ShimmerWidget.rectangular(
                      height: 12.h,
                      width: 100.w,
                    ),
                    SizedBox(
                      height: 08.h,
                    ),

                    /// User designation
                    ShimmerWidget.rectangular(
                      height: 12.h,
                      width: 100.w,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            /// post description
            ShimmerWidget.rectangular(
              height: 20.h,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),

            /// post image
            ShimmerWidget.rectangular(
              height: 120.h,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class PollCustomWidget extends StatelessWidget {
  PollCustomWidget({Key? key, this.postModel}) : super(key: key);
  PostModel? postModel;
  final CreatePostController createPostController = Get.find();
  int totalVotes = 0;
  bool isVoted = false;
  bool forDelay = false;
  int optionNumber = 0;

  @override
  Widget build(BuildContext context) {
    User? user = AuthServices().user;
    if (postModel?.options != null) {
      postModel?.options?.forEach((element) {
        if (element.votes != null) {
          totalVotes += element.votes!;
        }
      });
    }

    String pollJiffyStringMani = '';
    if (postModel?.pollExpireDate != null) {
      /// it will find the difference between post created time and date time now
      final jiffyTime = Jiffy(postModel?.pollExpireDate!).fromNow();

      /// Manipulate the string to show LinkedIn type dateTime in post
      pollJiffyStringMani = jiffyTime
          .toString()
          .replaceAll('hours ago', 'h')
          .replaceAll('days ago', 'd')
          .replaceAll('a day ago', '1 d')
          .replaceAll('minutes ago', 'm')
          .replaceAll('a few seconds ago', '0 m')
          .replaceAll('a minute ago', '1 m')
          .replaceAll('an hour ago', '1 h')
          .replaceAll('in 24 hours', '1d')
          .replaceAll('in 3 days', '3d')
          .replaceAll('in 7 days', '1w')
          .replaceAll('in 14 days', '2w')
          .replaceAll('an hour ago', '1 h')
          .replaceAll('in', '')
          .replaceAll('hours', 'h');

      /// it will check if the createdTime of poll is after the expirationTime so
      /// it means the poll is expired and we have to delete it
      var isPollExpire =
          Jiffy(DateTime.now()).isAfter(postModel?.pollExpireDate);

      if (isPollExpire) {
        PostsFirestoreDatebase().deletePostFromArenaScreen(postModel!.id!);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpacer(height: 24.h),
        Container(
          // height: 404.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius20),
            border: Border.all(color: AppColors.white500),
          ),
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 14,
            bottom: 08,
          ),

          /// Custom Poll container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                child: Text(
                  postModel?.postDescription != null
                      ? postModel!.postDescription.toString()
                      : 'dummy description',
                  style: AppTextStyle.bodyRegular.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(
                height: 14.h,
              ),

              /// poll options list
              Padding(
                padding: const EdgeInsets.only(bottom: 02),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),

                  /// This stream builder only used for to listen to user on tap on vote events
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('id', isEqualTo: postModel?.id)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading...");
                        }

                        /// converting firestore snapshot data into models
                        List<PollsList> listPollsModel = [];
                        // List<UserModel> commentUserModel = [];

                        /// firstore snapshot data
                        snapshot.data?.docs
                            .forEach((DocumentSnapshot documentSnap) async {
                          List<dynamic> firestorePolls = [];
                          if (documentSnap.exists) {
                            // firestorePolls = documentSnap.get('pollsList');
                            firestorePolls = documentSnap
                                    .data()
                                    .toString()
                                    .contains('pollsList')
                                ? documentSnap.get('pollsList')
                                : [];
                          }

                          if (firestorePolls.isNotEmpty) {
                            firestorePolls.forEach((singlePoll) {
                              PollsList pollModel = PollsList.fromJson(
                                  singlePoll as Map<String, dynamic>);

                              /// adding comment model into listOfComments
                              listPollsModel.add(pollModel);
                            });
                          }
                        });
                        return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: postModel?.options?.length,
                            itemBuilder: (context, index) {
                              final globalKey = GlobalKey();
                              PollOptions? option = postModel?.options![index];
                              String? percentage;

                              /// ~/ is used for integer division
                              /// if totalVotes value is greater than 0 then find its percent
                              if (totalVotes > 0 && option?.votes != 0) {
                                percentage = (option!.votes! / totalVotes * 100)
                                    .toInt()
                                    .toString();
                              } else if (option?.votes == 0) {
                                /// if option.votes is 0 the percentage will equal to 0
                                percentage = '0';
                              }
                              isVoted = false;

                              listPollsModel.forEach((element) {
                                if (element.uid == user?.uid) {
                                  isVoted = true;
                                  optionNumber = element.option!;
                                  print(
                                      '........ ${listPollsModel.indexOf(element)}');
                                }
                              });
                              // });
                              // print(
                              //     'isVoted value: $isVoted ,, option: $optionNumber');

                              return isVoted == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: LinearPercentIndicator(
                                        // key: globalKey,
                                        animation: true,
                                        animationDuration: 1000,
                                        lineHeight: 45.h,
                                        // width: MediaQuery.of(context)
                                        //     .size
                                        //     .width -
                                        // 50,

                                        percent: option?.votes != null
                                            ? option!.votes! / totalVotes
                                            : 0,

                                        // linearStrokeCap:
                                        // LinearStrokeCap.roundAll,
                                        progressColor: Colors.blueGrey,
                                        backgroundColor: Colors.black,
                                        barRadius: const Radius.circular(10),

                                        center: Row(
                                          // mainAxisAlignment:
                                          //MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              option!.optionDescription
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            optionNumber - 1 == index
                                                ? const Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.white,
                                                    size: 14,
                                                  )
                                                : Container(),
                                            Spacer(),
                                            Text(
                                              '${percentage}%  ',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )

                                  /// Show this widget when user didn't vote yet
                                  : Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CommonButton(
                                        title: postModel!
                                            .options![index].optionDescription
                                            .toString(),
                                        textColor: Colors.blueAccent,
                                        borderColor: Colors.blueAccent,
                                        iconData: '',
                                        isPoll: true,
                                        isFill: false,
                                        isIconVisible: false,
                                        onPressed: () {
                                          User? currentUser =
                                              AuthServices().user;
                                          List<PollOptions>? optionsList =
                                              postModel?.options!;
                                          optionsList![index] = PollOptions(
                                            option: index + 1,
                                            optionDescription:
                                                optionsList[index]
                                                    .optionDescription,
                                            votes: optionsList[index].votes !=
                                                    null
                                                ? optionsList[index].votes! + 1
                                                : 1,
                                          );
                                          // print(
                                          //     'list of options222:  ${optionsList![pollOption.id! - 1].optionDescription}, ');

                                          // await Future.delayed(const Duration(seconds: 1));

                                          createPostController
                                              .voteOnPollFieldController(
                                                  postModel!.id!, optionsList);
                                          String currentUserUID =
                                              AuthServices().user!.uid;
                                          PollsList polls = PollsList(
                                            uid: currentUserUID,
                                            option: index + 1,
                                            duration:
                                                Timestamp.now().toString(),
                                          );
                                          createPostController
                                              .updateVotersFieldController(
                                                  postModel!.id!, polls);
                                        },
                                        iconColor: AppColors.transparent,
                                        buttonShouldDisable: false,
                                      ),
                                    );
                            });
                      }),
                ),
              ),

              const SizedBox(
                height: 08,
              ),

              /// Poll Meta Data
              Row(
                children: [
                  SizedBox(width: 6),
                  Text(
                    '${totalVotes.toString()} votes',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(width: 6),
                  const Text(
                    '•',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${pollJiffyStringMani} left',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
        VerticalSpacer(height: 21.h),
      ],
    );
  }
}
