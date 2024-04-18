import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/controller/create_post_controller.dart';
import 'package:vip_connect/controller/post_controller.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/model/GroupChatModel.dart';
import 'package:vip_connect/model/post_model.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/shimmer_widget.dart';

import '../../../config/routes.dart';
import '../../../services/firebase_auth.dart';
import '../../components/common_Icon_button.dart';
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
  TextEditingController _searchController = TextEditingController();
  // Map<String, List<dynamic>>? _listUserModel = {};
  List<UserModel> _listUserModel = [];
  List<GroupChatModel> _listGroupChatModel = [];
  List<dynamic> _listModelsOnSearch = [];

  @override
  void initState() {
    /// Get Users data from firestore for Searching
    getUserListFromCollection();
    // TODO: implement initState
    super.initState();
    // _fetchData();
    Future.delayed(Duration(seconds: 3), () {
      /// we delayed this for showing shammer effects
      sharedPostCalledLimit = true;
      setState(() {});
    });
  }

  getUserListFromCollection() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    /// get user list for searching
    FirebaseFirestore.instance
        .collection("user")
        .where('uid', isNotEqualTo: currentUserUid)
        .snapshots()
        .listen((userDocs) {
      _listUserModel.clear();
      userDocs.docs.forEach((user) {
        UserModel _user = UserModel.fromJson(user.data());
        _listUserModel.add(_user);
      });
      setState(() {});
    });

    /// get channels list for searching
    FirebaseFirestore.instance
        .collection("groupChat")
        // .where('uid', isNotEqualTo: currentUserUid)
        .snapshots()
        .listen((userDocs) {
      _listGroupChatModel.clear();
      userDocs.docs.forEach((groupChatData) {
        print('search group chat data:: ${groupChatData.data()}');
        GroupChatModel _group = GroupChatModel.fromJson(groupChatData.data());
        _listGroupChatModel.add(_group);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'original user list length: ${_listUserModel.length} ,, group: ${_listGroupChatModel.length}');
    print('original user list length2: ${_listModelsOnSearch.length}');
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
                            controller: _searchController,
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
                            onChanged: (value) {
                              setState(() {
                                // _listUserModelOnSearch = _listUserModel
                                //     .where(
                                //       (element) => element.fullName
                                //           .toLowerCase()
                                //           .contains(value!.toLowerCase()),
                                //     )
                                //     .toList();

                                _listModelsOnSearch.clear();

                                /// Search user connections list
                                if (_listUserModel.isNotEmpty) {
                                  for (var user in _listUserModel) {
                                    if (user.fullName!
                                        .toLowerCase()
                                        .contains(value!.toLowerCase())) {
                                      _listModelsOnSearch.add(user);
                                    }
                                  }
                                }

                                /// Search group chat channels list
                                if (_listGroupChatModel.isNotEmpty) {
                                  for (var group in _listGroupChatModel) {
                                    if (group.name!
                                        .toLowerCase()
                                        .contains(value!.toLowerCase())) {
                                      _listModelsOnSearch.add(group);
                                    }
                                  }
                                }
                              });
                            },
                            onSaved: (String? newValue) {},
                            validator: (String? value) {},
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),

                        /// Notification button
                        // Container(
                        //   height: 50.h,
                        //   width: 50.w,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(16),
                        //       color: AppColors.button),
                        //   child: SvgPicture.asset(AppAssets.bellSvg),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: InkWell(
                            onTap: () {
                              print('button clicked');
                              Get.toNamed(routeNotificationScreen);
                            },
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
          child:

              /// Condition for search
              _searchController.text.isNotEmpty && _listModelsOnSearch.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(left: 22.0),
                      child: Text(
                        'No results found... ',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )
                  : _searchController.text.isNotEmpty

                      /// Show search result
                      ? ListView.builder(
                          shrinkWrap: true,
                          // primary: false,
                          itemCount: _searchController.text.isNotEmpty
                              ? _listModelsOnSearch.length
                              : _listUserModel.length,
                          itemBuilder: (context, index) {
                            var item = _searchController.text.isNotEmpty
                                ? _listModelsOnSearch[index]
                                : _listUserModel[index];

                            // final currentUser = AuthServices().user;

                            if (item is UserModel) {
                              return InkWell(
                                onTap: () {
                                  /// go to user detail screen [vip detail]
                                  Get.toNamed(
                                    routeVipDetailScreen,
                                    arguments: [item.uid.toString(), 'none'],
                                  );
                                },
                                child: Column(
                                  children: [
                                    /// User Profile
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 55.h,
                                            width: 55.h,
                                            child: CircleAvatar(
                                              /// User  picture inside post
                                              child: item.profileImage != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: item
                                                          .profileImage
                                                          .toString(),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
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
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                  item.firstName != null
                                                      ? '${item.firstName} ${item.lastName}'
                                                      : "Jonathan Cooper",
                                                  style:
                                                      AppTextStyle.bodyMedium,
                                                  // style: AppTextStyle.bodyMedium.copyWith(
                                                  //   fontSize: kFontSize11,
                                                  //   fontWeight: FontWeight.w600,
                                                  // ),
                                                ),

                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    /// Designation text
                                                    Text(
                                                      item.jobTitle != null
                                                          ? '${item.jobTitle}'
                                                          : " ",
                                                      style: AppTextStyle
                                                          .bodyMedium
                                                          .copyWith(
                                                        fontSize: 10,
                                                        color: Colors.white54,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),

                                                    /// Company name
                                                    Text(
                                                      item.employerName != null
                                                          ? ' @ ${item.employerName}'
                                                          : " ",
                                                      style: AppTextStyle
                                                          .bodyMedium
                                                          .copyWith(
                                                        fontSize: 10,
                                                        color: Colors.white54,
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
                                          Text(
                                            'Connection',
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.bodyMedium
                                                .copyWith(
                                              fontSize: 12,
                                              color: Colors.white54,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (item is GroupChatModel) {
                              /// Group Chat Search Result
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(routeGroupMessageScreen,
                                      arguments: {
                                        'groupId': item.groupId,
                                        'groupName': item.name
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 55.h,
                                        width: 55.h,
                                        child: CircleAvatar(
                                          /// User  picture inside post
                                          child: item.groupImage != null &&
                                                  item.groupImage != ''
                                              ? CachedNetworkImage(
                                                  imageUrl: item.groupImage
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
                                            /// Group name
                                            Text(
                                              item.name.toString(),
                                              style: AppTextStyle.bodyMedium,
                                              // style: AppTextStyle.bodyMedium.copyWith(
                                              //   fontSize: kFontSize11,
                                              //   fontWeight: FontWeight.w600,
                                              // ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            item.lastMessage != null &&
                                                    item.lastMessage != ''
                                                ? Text(
                                                    item.lastMessage.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTextStyle
                                                        .bodyMedium
                                                        .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  )
                                                : Container(),

                                            SizedBox(height: 3.h),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Channel',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          fontSize: 12,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        )
                      : FirestoreListView<PostModel>(
                          query: _postQuery,
                          pageSize: 20,
                          cacheExtent: 1.1,
                          itemBuilder: (BuildContext context,
                              QueryDocumentSnapshot<dynamic> doc) {
                            /// data is now typed
                            PostModel postModel = doc.data();

                            /// it will find the difference between post created time and date time now
                            final jiffyTime =
                                Jiffy(postModel.createdAt!.toDate()).fromNow();

                            /// Manipulate the string to show LinkedIn type dateTime in post
                            String jiffyStringMani = jiffyTime
                                .toString()
                                .replaceAll(' hours ago', 'h')
                                .replaceAll(' days ago', 'd')
                                .replaceAll('a day ago', '1d')
                                .replaceAll(' minutes ago', 'm')
                                .replaceAll('a few seconds ago', '0m')
                                .replaceAll('in a few seconds', '0m')
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
                                          String currentUserUID =
                                              AuthServices().user!.uid;
                                          createPostController
                                              .updateLikesFieldController(
                                                  postModel.id!,
                                                  currentUserUID);
                                        },

                                        /// DisLike: onTap
                                        onTapDisLiked: () {
                                          String currentUserUID =
                                              AuthServices().user!.uid;
                                          createPostController
                                              .updateDislikesFieldController(
                                                  postModel.id!,
                                                  currentUserUID);
                                        },

                                        /// Comment: onTap
                                        onTapComment: () {
                                          Get.toNamed(routeCommentPost,
                                              arguments: [
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
