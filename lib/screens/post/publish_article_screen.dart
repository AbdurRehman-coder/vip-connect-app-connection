import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as locate;
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';

import '../../controller/create_post_controller.dart';
import '../../controller/post_controller.dart';
import '../../model/post_model.dart';
import '../../services/firebase_auth.dart';
import '../components/custom_textfield.dart';

class PublishArticleScreen extends StatefulWidget {
  PublishArticleScreen({Key? key}) : super(key: key);

  @override
  State<PublishArticleScreen> createState() => _PublishArticleScreenState();
}

class _PublishArticleScreenState extends State<PublishArticleScreen> {
  final PostController _postController = Get.find();
  final CreatePostController _createPostController = Get.find();

  /// Text Editing Controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();

  bool isPostButtonClicked = true;
  locate.Location location = locate.Location();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(
        title: AppTexts.publishArticle,
      ),
      bottomNavigationBar: Container(
        color: AppColors.secondary,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: Get.context != null
              ? MediaQuery.of(Get.context!).viewInsets.bottom == 0
                  ? 22.h
                  : MediaQuery.of(Get.context!).viewInsets.bottom
              : 22.h,
        ),
        child: InkWell(
          onTap: () {
            /// Open dialog to show the two options [Camera, Gallery]
            /// image widget
            _postController.chooseImageDestination(articlePost: true);
          },
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.imageSvg),
              const Text(
                'Select image',
                style: TextStyle(color: Colors.white),
              ),
              // IconButton(
              //     onPressed: () {
              //       Util.showListOfNewPostOptionsBottomSheet();
              //     },
              //     icon: SvgPicture.asset(AppAssets.moreHorizontalSvg)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        child: Obx(
          () => SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      splashRadius: 20.r,
                      icon: SvgPicture.asset(AppAssets.closeSvg),
                    ),

                    SizedBox(height: 40.h),

                    /// Headline text
                    const Text(
                      'Headline',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),

                    /// Article Headline
                    CustomTextField(
                      controller: _headlineController,
                      mainTitle: "What do you want to talk about?",
                      hideMainTitle: true,
                      disableBorder: true,
                      cursorColor: Colors.white,
                      hintText: "Article headline",
                      hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                          color: AppColors.disableText,
                          fontWeight: FontWeight.normal),
                      textStyle: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.white,
                      ),
                      filled: false,
                      maxLines: 5,
                      onSaved: (String? newValue) {},
                      validator: (headline) =>
                          headline!.trim() != null && headline.trim().length < 5
                              ? 'Enter a minimum of 5 characters'
                              : null,
                    ),

                    /// Article Description text
                    const Text(
                      'Description',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    /// Article Description
                    CustomTextField(
                      controller: _descriptionController,
                      mainTitle: "Write your description...",
                      hideMainTitle: true,
                      disableBorder: true,
                      cursorColor: Colors.white,
                      hintText: "Article description...",
                      hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.disableText,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      textStyle: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.white,
                      ),
                      filled: false,
                      maxLines: 5,
                      onSaved: (String? newValue) {},
                      validator: (description) => description?.trim() != null &&
                              description!.trim().length < 5
                          ? 'Enter a minimum of 5 characters'
                          : null,
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                    _postController.articlePickedImage.value.path.isNotEmpty
                        ? Container(
                            child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                  // borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                File(_postController
                                    .articlePickedImage.value.path),
                                fit: BoxFit.fitHeight,
                              )),
                              CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: IconButton(
                                  onPressed: () {
                                    _postController.articlePickedImage.value =
                                        XFile('');
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                            // ? ClipRRect(
                            //     // borderRadius: BorderRadius.circular(100),
                            //     child: Image.file(
                            //     File(_postController
                            //         .articlePickedImage.value.path),
                            //     fit: BoxFit.fitHeight,
                            //   ))

                            )
                        : Container(
                            height: 200,
                            width: double.infinity,
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    _postController.isLoading.value
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          )
                        : CommonButton(
                            title: 'Post',
                            iconData: '',
                            isFill: true,
                            isIconVisible: false,
                            onPressed: isPostButtonClicked == true
                                ? () async {
                                    /// Get the user location at the time when it post this
                                    /// we getting only main city and its state
                                    locate.LocationData _locationData;
                                    _locationData =
                                        await location.getLocation();
                                    List<Placemark> placemarks =
                                        await placemarkFromCoordinates(
                                            _locationData.latitude!,
                                            _locationData.longitude!);
                                    print(
                                        'locatiion data: ${_locationData} addrss: ${placemarks}');

                                    final isValid =
                                        _formKey.currentState!.validate();
                                    if (!isValid) return;

                                    setState(() {
                                      isPostButtonClicked = false;
                                    });

                                    ///Button onTap
                                    /// Get posts documents length, for post id
                                    final QuerySnapshot qSnap =
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .get();
                                    _postController.updateIsLoading(true);

                                    final int documentsLength =
                                        qSnap.docs.length;

                                    // Get.back();
                                    String imageURL = '';
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    if (_postController.articlePickedImage.value
                                        .path.isNotEmpty) {
                                      /// Create a Reference to the file
                                      Reference storageRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('posts')
                                          .child('/post${user?.uid}');

                                      /// upload the image
                                      UploadTask uploadTask = storageRef
                                          .putFile(File(_postController
                                              .articlePickedImage.value.path));
                                      await Future.value(uploadTask);
                                      imageURL =
                                          await storageRef.getDownloadURL();
                                    }

                                    PostModel postModel = PostModel(
                                      id: documentsLength + 1,
                                      uid: AuthServices().user?.uid.toString(),
                                      createdAt: Timestamp.now(),
                                      postDescription: _descriptionController
                                          .text
                                          .toString(),
                                      articleHeadline:
                                          _headlineController.text.toString(),
                                      postType: 'articlePost',
                                      postAddress:
                                          '${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}',
                                      likes: [],
                                      dislikes: [],
                                      shares: [],
                                      comments: [],
                                      postImage: imageURL,
                                    );
                                    print(
                                        'post model before posting: ${postModel}');
                                    _createPostController
                                        .createPost(postModel)
                                        .then((value) {
                                      _postController.updateIsLoading(false);
                                      _postController.clearImage();
                                    }).onError((error, stackTrace) =>
                                            _postController
                                                .updateIsLoading(false));

                                    _postController.updateIsLoading(false);
                                  }
                                : () {},
                            iconColor: AppColors.transparent,
                            buttonShouldDisable: false,
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
