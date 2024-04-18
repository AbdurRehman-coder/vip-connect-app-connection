import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locate;
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../controller/create_post_controller.dart';
import '../../controller/post_controller.dart';
import '../../model/post_model.dart';
import '../../model/user_model.dart';
import '../../services/firebase_auth.dart';
import '../components/custom_post.dart';

class SharePostScreen extends StatefulWidget {
  const SharePostScreen({Key? key}) : super(key: key);

  @override
  State<SharePostScreen> createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  dynamic argumentsData = Get.arguments;
  TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User currentUser = AuthServices().user!;

  /// Getting controller from getX
  final PostController _postController = Get.find();
  final CreatePostController _createPostController = Get.find();
  UserModel? userrModel;
  String postUniqueID = '';

  /// to disable post button after clicked once
  bool isPostButtonClicked = true;
  locate.Location location = locate.Location();

  @override
  void initState() {
    PostModel postModelData = argumentsData[0];
    getUserData();
    // TODO: implement initState
    super.initState();

    /// Create a reference to the cities collection
    CollectionReference postRef =
        FirebaseFirestore.instance.collection("posts");

    /// Create a query against the collection.
    postRef.where("id", isEqualTo: postModelData.id).get().then((query) {
      query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
        postRef.doc(documentSnapshot.id).get().then((docSnap) {
          postUniqueID = documentSnapshot.id;
          setState(() {});
          // PostModel posttModel = PostModel.fromJson(
          //     docSnap.data() as Map<String, dynamic>);
          // sharePostModel = posttModel;
          // model.setSharedPostModel(posttModel);
        });
      });
    });
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
    PostModel postModelData = argumentsData[0];
    UserModel userModel = argumentsData[1];
    String jiffyStringMani = argumentsData[2];
    String userUID = AuthServices().user!.uid;

    return Scaffold(
      appBar: customAppBar(title: AppTexts.sharePost, action: [
        IconButton(
            onPressed: () {},
            splashRadius: 20.r,
            icon: SvgPicture.asset(
              AppAssets.closeSvg,
              color: AppColors.primary,
              height: 24.h,
              width: 24.w,
            ))
      ]),
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                VerticalSpacer(height: 40.h),

                /// Description TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white30.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(08),
                  ),
                  child: CustomTextField(
                    controller: _descriptionController,
                    mainTitle: "What do you want to talk about?",
                    hideMainTitle: true,
                    disableBorder: true,
                    cursorColor: Colors.white,
                    hintText: "What do you want to talk about?",
                    hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                    textStyle: AppTextStyle.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                    filled: false,
                    maxLines: 5,
                    onSaved: (String? newValue) {},
                    validator: (description) => description?.trim() != null &&
                            description!.trim().length < 2
                        ? 'Enter some text'
                        : null,
                  ),
                ),

                VerticalSpacer(height: 8.h),

                CustomPost(
                  postModel: postModelData,
                  createdTime: jiffyStringMani,
                  isSharePost: true,

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
                VerticalSpacer(height: 40.h),

                /// Custom Button
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: CommonButton(
                      title: 'Post',
                      iconData: '',
                      isFill: true,
                      isIconVisible: false,
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
                              print(
                                  'lcoation on share:: $_locationData ,, address: $placemarks');

                              final isValid = _formKey.currentState!.validate();
                              if (!isValid) return;

                              setState(() {
                                isPostButtonClicked = false;
                              });
                              final QuerySnapshot qSnap =
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .get();
                              final int documentsLength = qSnap.docs.length;

                              _postController.updateIsLoading(true);
                              // Get.back();
                              String imageURL = '';
                              String videoURL = '';

                              if (postModelData.postType == 'poll') {
                                List<PollOptions> pollOptionsList = [];

                                /// Create a reference to the cities collection
                                CollectionReference postRef =
                                    await FirebaseFirestore.instance
                                        .collection("posts");

                                /// Create a query against the collection.
                                QuerySnapshot query = await postRef
                                    .where("id", isEqualTo: postModelData.id)
                                    .get();
                                query.docs.forEach((QueryDocumentSnapshot
                                    documentSnapshot) async {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(documentSnapshot.id)
                                      .get()
                                      .then((value) {
                                    Map<String, dynamic>? data = value.data();
                                    if (data != null) {
                                      data['options'].forEach((val) {
                                        pollOptionsList.add(
                                          PollOptions(
                                              optionDescription:
                                                  val['optionDescription'],
                                              option: val['option'],
                                              votes: 0),
                                        );
                                      });
                                    }
                                  });
                                });
                                Future.delayed(Duration(seconds: 1), () {
                                  print(
                                      'polls options votes: ${pollOptionsList.length}');
                                  PostModel postModel = PostModel(
                                    id: documentsLength + 1,
                                    sharePostId: postUniqueID,
                                    uid: currentUser.uid.toString(),
                                    createdAt: Timestamp.now(),
                                    postDescription:
                                        _descriptionController.text.toString(),
                                    postType: 'sharePost',
                                    postAddress:
                                        '${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}',
                                    likes: [],
                                    dislikes: [],
                                    comments: [],
                                    options: pollOptionsList,
                                    postImage: imageURL.isNotEmpty
                                        ? imageURL
                                        : videoURL,
                                  );
                                  _createPostController
                                      .createPost(postModel)
                                      .then((value) {
                                    int shareLength =
                                        postModelData.sharesLength! + 1;
                                    _createPostController
                                        .updateShareFieldController(
                                            postModelData.id!,
                                            currentUser.uid.toString(),
                                            shareLength);
                                    _postController.clearImage();
                                    _postController.clearVideo();
                                    _postController.clearUncompressedVideo();
                                  });
                                  _postController.updateIsLoading(false);
                                });
                              } else {
                                PostModel postModel = PostModel(
                                  id: documentsLength + 1,
                                  sharePostId: postUniqueID,
                                  uid: currentUser.uid.toString(),
                                  createdAt: Timestamp.now(),
                                  postDescription:
                                      _descriptionController.text.toString(),
                                  postType: 'sharePost',
                                  likes: [],
                                  dislikes: [],
                                  comments: [],
                                  postImage:
                                      imageURL.isNotEmpty ? imageURL : videoURL,
                                );
                                _createPostController
                                    .createPost(postModel)
                                    .then((value) {
                                  int shareLength =
                                      postModelData.sharesLength! + 1;
                                  _createPostController
                                      .updateShareFieldController(
                                          postModelData.id!,
                                          currentUser.uid.toString(),
                                          shareLength);
                                  _postController.clearImage();
                                  _postController.clearVideo();
                                  _postController.clearUncompressedVideo();
                                });
                                _postController.updateIsLoading(false);
                              }
                            }
                          : () {},
                      iconColor: AppColors.transparent,
                      buttonShouldDisable: false,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
