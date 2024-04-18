import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/controller/create_post_controller.dart';
import 'package:vip_connect/model/post_model.dart';

import '../../controller/post_controller.dart';
import '../../helper/app_assets.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_text_styles.dart';
import '../components/common_button.dart';
import '../components/custom_textfield.dart';

class EditArenaPostScreen extends StatefulWidget {
  EditArenaPostScreen({Key? key, this.postModel}) : super(key: key);
  PostModel? postModel;
  @override
  State<EditArenaPostScreen> createState() => _EditArenaPostScreenState();
}

class _EditArenaPostScreenState extends State<EditArenaPostScreen> {
  final PostController _postController = Get.find();

  final CreatePostController _createPostController =
      Get.put(CreatePostController());

  TextEditingController? _descriptionController;
  TextEditingController? _headlineController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.postModel?.postDescription);
    if (widget.postModel?.postType == 'articlePost') {
      _headlineController =
          TextEditingController(text: widget.postModel?.articleHeadline);
    }
  }

  @override
  Widget build(BuildContext context) {
    // PostController postController = Get.put(PostController());
    return Scaffold(
      backgroundColor: AppColors.secondary,
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
        child: Row(
          children: [
            // IconButton(
            //     onPressed: () {
            //       /// Open dialog to show the two options [Camera, Gallery]
            //       /// Video widget
            //       _postController.chooseVideoDestination();
            //     },
            //     icon: SvgPicture.asset(AppAssets.videoCameraSvg)),
            /// for image
            // IconButton(
            //     onPressed: () {
            //       /// Open dialog to show the two options [Camera, Gallery]
            //       /// image widget
            //       _postController.chooseImageDestination();
            //     },
            //     icon: SvgPicture.asset(AppAssets.imageSvg)),

            // IconButton(
            //     onPressed: () {
            //       Util.showListOfNewPostOptionsBottomSheet();
            //     },
            //     icon: SvgPicture.asset(AppAssets.moreHorizontalSvg)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  splashRadius: 20.r,
                  icon: SvgPicture.asset(AppAssets.closeSvg),
                ),
                SizedBox(height: 80.h),
                widget.postModel?.postType == 'articlePost'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            mainTitle: _headlineController!.text.toString(),
                            hideMainTitle: true,
                            disableBorder: true,
                            cursorColor: Colors.white,
                            hintText: "Article headline",
                            hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                                color: AppColors.disableText,
                                fontWeight: FontWeight.normal),
                            textStyle: AppTextStyle.bodyRegular.copyWith(
                              color: AppColors.disableText,
                            ),
                            filled: false,
                            maxLines: 5,
                            onSaved: (String? newValue) {},
                            validator: (String? value) {},
                            // validator: (headline) =>
                            //     headline != null && headline.length < 5
                            //         ? 'Enter min. 5 character'
                            //         : null,
                          ),
                        ],
                      )
                    : Container(),

                /// Article Description text
                const Text(
                  'Description',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),

                ///Post Description
                CustomTextField(
                  controller: _descriptionController,
                  mainTitle: _descriptionController!.text.toString(),
                  hideMainTitle: true,
                  disableBorder: true,
                  cursorColor: Colors.white,
                  hintText: "What do you want to talk about?",
                  hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                    color: AppColors.white,
                  ),
                  textStyle: AppTextStyle.bodyRegular.copyWith(
                    color: AppColors.disableText,
                  ),
                  filled: false,
                  maxLines: 5,
                  onSaved: (String? newValue) {},
                  validator: (String? value) {},
                ),
                SizedBox(height: 30.h),
                // widget.postModel?.postImage != null
                _postController.pickedImage.value.path.isNotEmpty
                    ? Container(
                        height: 300.h,
                        width: double.infinity.h,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          color: AppColors.white300,
                          border:
                              Border.all(color: AppColors.white300, width: 4.w),
                        ),
                        child: _postController.pickedImage.value.path.isNotEmpty
                            ? ClipRRect(
                                // borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                File(_postController.pickedImage.value.path),
                                fit: BoxFit.fitHeight,
                              ))
                            : Image.asset(
                                AppAssets.dummyPostImg,
                              ),
                      )

                    /// Post image
                    : Image.network(
                        widget.postModel!.postImage.toString(),
                        fit: BoxFit.fitHeight,
                        height: 200,
                        width: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, exception, stackTrace) {
                          return Image.asset(
                            AppAssets.dummyPostImg,
                            fit: BoxFit.cover,
                            // height: (widget.hideBelowImage == null ||
                            //     widget.hideBelowImage == false)
                            //     ? 170.h
                            //     : 130.h,
                            width: double.infinity,
                          );
                        },
                      ),
                SizedBox(
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
                        onPressed: _postController.isLoading.value == false
                            ? () async {
                                _postController.updateIsLoading(true);

                                ///TODO: it will be used in future, because we can also update our image or video
                                /// Get posts documents length, for post id
                                // final QuerySnapshot postSnap =
                                //     await FirebaseFirestore.instance
                                //         .collection('posts')
                                //         .get();
                                // final int documentsLength =
                                //     postSnap.docs.length;
                                // // Get.back();
                                // String imageURL = '';
                                // User? user = FirebaseAuth.instance.currentUser;
                                // if (_postController
                                //     .pickedImage.value.path.isNotEmpty) {
                                //   Timestamp timeStamp = Timestamp.now();
                                //
                                //   /// Create a Reference to the file
                                //   Reference storageRef = FirebaseStorage
                                //       .instance
                                //       .ref()
                                //       .child('posts')
                                //       .child('/post${timeStamp}.${user?.uid}');
                                //
                                //   /// upload the image
                                //   UploadTask uploadTask = storageRef.putFile(
                                //       File(_postController
                                //           .pickedImage.value.path));
                                //   await Future.value(uploadTask);
                                //   imageURL = await storageRef.getDownloadURL();
                                // }

                                _createPostController
                                    .editeArenaPostController(
                                  postId: widget.postModel!.id!,
                                  description: _descriptionController!.text,
                                  articleHeadline:
                                      _headlineController?.text.toString(),
                                  // imageURL:
                                  //     imageURL.isNotEmpty ? imageURL : null,
                                  postType: widget.postModel?.postType,
                                )
                                    .then((value) {
                                  _postController.updateIsLoading(false);
                                  _postController.clearImage();
                                  _descriptionController?.clear();
                                  _headlineController?.clear();
                                }).onError((error, stackTrace) =>
                                        _postController.updateIsLoading(false));
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
    );
  }
}
