import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locate;

import '../../controller/create_post_controller.dart';
import '../../controller/post_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_text_styles.dart';
import '../../model/post_model.dart';
import '../../services/firebase_auth.dart';
import '../components/common_button.dart';
import '../components/custom_appbar.dart';
import '../components/custom_textfield.dart';

class CreateDocumentPostScreen extends StatefulWidget {
  const CreateDocumentPostScreen({Key? key}) : super(key: key);

  @override
  State<CreateDocumentPostScreen> createState() =>
      _CreateDocumentPostScreenState();
}

class _CreateDocumentPostScreenState extends State<CreateDocumentPostScreen> {
  final PostController _postController = Get.find();

  final CreatePostController _createPostController =
      Get.put(CreatePostController());

  final TextEditingController _descriptionController = TextEditingController();

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();

  /// to disable post button after clicked once
  bool isPostButtonClicked = true;
  locate.Location location = locate.Location();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      /// custom app bar
      appBar: customAppBar(
        title: "Document Post",
        // title: createPostController.postsModel.length.toString() ?? '',
        hideBackButton: false,
        centerTitle: true,
      ),

      /// bottom sheet for selecting document
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
            _postController.getDocumentFromDevice();
          },
          child: Row(
            children: [
              /// Open dialog to show the two options [Camera, Gallery]
              /// image widget
              Icon(
                Icons.file_copy_outlined,
                color: Colors.white.withOpacity(0.6),
              ),
              SizedBox(
                width: 08,
              ),
              Text(
                'Select Document',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
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
          () => _postController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 80.h),

                          /// Document Description text
                          const Text(
                            'Description',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 08,
                          ),
                          CustomTextField(
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
                            validator: (description) =>
                                description?.trim() != null &&
                                        description!.trim().length < 5
                                    ? 'Enter min. 5 character'
                                    : null,
                          ),
                          SizedBox(height: 30.h),

                          Text(
                            'document: ${_postController.pickedDocument.value.name}',
                            style: const TextStyle(color: Colors.white),
                          ),

                          // Container(
                          //   height: 300.h,
                          //   width: double.infinity.h,
                          //   clipBehavior: Clip.hardEdge,
                          //   decoration: BoxDecoration(
                          //     // shape: BoxShape.circle,
                          //     color: AppColors.white300,
                          //     border: Border.all(
                          //         color: AppColors.white300, width: 4.w),
                          //   ),
                          //   child: _postController
                          //           .pickedImage.value.path.isNotEmpty
                          //       ? ClipRRect(
                          //           // borderRadius: BorderRadius.circular(100),
                          //           child: Image.file(
                          //           File(_postController.pickedImage.value.path),
                          //           fit: BoxFit.fitHeight,
                          //         ))
                          //       : Image.asset(
                          //           AppAssets.dummyPostImg,
                          //         ),
                          // ),
                          SizedBox(
                            height: 80,
                          ),
                          CommonButton(
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

                                    final isValid =
                                        _formKey.currentState!.validate();
                                    if (!isValid) return;

                                    String fileExtension = '';
                                    setState(() {
                                      isPostButtonClicked = false;
                                    });

                                    ///Button onTap
                                    /// Get posts documents length, for post id
                                    final QuerySnapshot qSnap =
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .get();
                                    final int documentsLength =
                                        qSnap.docs.length;

                                    _postController.updateIsLoading(true);
                                    // Get.back();
                                    String DocURL = '';
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    if (_postController
                                        .pickedDocument.value.path.isNotEmpty) {
                                      fileExtension = _postController
                                          .pickedDocument.value.path
                                          .split('.')
                                          .last;
                                      Timestamp timeStamp = Timestamp.now();

                                      /// Create a Reference to the file
                                      Reference storageRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('postDoc')
                                          .child(
                                              '/postDocument${timeStamp}.${user?.uid}');

                                      /// upload the image
                                      UploadTask uploadTask = storageRef
                                          .putFile(File(_postController
                                              .pickedDocument.value.path));
                                      await Future.value(uploadTask);
                                      DocURL =
                                          await storageRef.getDownloadURL();
                                    } else {}

                                    PostModel postModel = PostModel(
                                      id: documentsLength + 1,
                                      uid: AuthServices().user?.uid.toString(),
                                      createdAt: Timestamp.now(),
                                      postDescription: _descriptionController
                                          .text
                                          .toString(),
                                      postType: 'DocPost',
                                      fileType: fileExtension,
                                      postAddress:
                                          '${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}',
                                      likes: [],
                                      dislikes: [],
                                      shares: [],
                                      comments: [],
                                      postImage: DocURL,
                                    );
                                    print(
                                        'post model before posting: ${postModel.postImage}');
                                    _createPostController
                                        .createPost(postModel)
                                        .then((value) =>
                                            _postController.clearDocument());
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
