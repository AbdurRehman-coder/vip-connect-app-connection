import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locate;
import 'package:video_player/video_player.dart';
import 'package:vip_connect/controller/create_post_controller.dart';

import '../../controller/post_controller.dart';
import '../../helper/app_assets.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_text_styles.dart';
import '../../model/post_model.dart';
import '../../services/firebase_auth.dart';
import '../../utils/util.dart';
import '../components/common_button.dart';
import '../components/custom_textfield.dart';

class CreatePostMainScreen extends StatefulWidget {
  CreatePostMainScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostMainScreen> createState() => _CreatePostMainScreenState();
}

class _CreatePostMainScreenState extends State<CreatePostMainScreen> {
  final PostController _postController = Get.find();

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();

  final CreatePostController _createPostController =
      Get.put(CreatePostController());

  final TextEditingController _descriptionController = TextEditingController();
  bool isVideoPicked = true;
  locate.Location location = locate.Location();

  /// Video player controller
  VideoPlayerController? _videoController;

  bool isPostButtonClicked = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = VideoPlayerController.file(
    //   _postController.pickedVideo.value,
    // )..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
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
            IconButton(
                onPressed: () {
                  /// Open dialog to show the two options [Camera, Gallery]
                  /// Video widget
                  _postController.chooseVideoDestination();
                },
                icon: SvgPicture.asset(AppAssets.videoCameraSvg)),
            IconButton(
                onPressed: () {
                  /// Open dialog to show the two options [Camera, Gallery]
                  /// image widget
                  _postController.chooseImageDestination();

                  if (_postController.pickedVideo.value.path.isNotEmpty) {}
                },
                icon: SvgPicture.asset(AppAssets.imageSvg)),
            IconButton(
                onPressed: () {
                  Util.showListOfNewPostOptionsBottomSheet();
                },
                icon: SvgPicture.asset(AppAssets.moreHorizontalSvg)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        child: Obx(() {
          print(
              'on image selected.... ${_postController.pickedImage.value.path}');
          if (_postController.pickedVideo.value.path.isNotEmpty &&
              isVideoPicked == true) {
            isVideoPicked = false;
            print(
                'onpress video file11;: ${_postController.pickedVideo.value.path}');
            _videoController = VideoPlayerController.file(
              _postController.pickedVideo.value,
            )..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {
                  //   _videoController?.play();
                });
              });
          }
          return SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Form(
                key: _formKey,
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
                      validator: (description) => description?.trim() != null &&
                              description!.trim().length < 2
                          ? 'Enter some text'
                          : null,
                    ),
                    SizedBox(height: 30.h),
                    _postController.pickedImage.value.path.isNotEmpty
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                  // borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                File(_postController.pickedImage.value.path),
                                fit: BoxFit.fitHeight,
                              )),
                              CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: IconButton(
                                  onPressed: () {
                                    _postController.clearImage();
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )

                        /// Video preview widget
                        : _postController.pickedVideo.value.path.isNotEmpty
                            ? Container(
                                color: Colors.white54,
                                child: _videoController != null &&
                                        _videoController!.value.isInitialized
                                    ? Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: AspectRatio(
                                              aspectRatio: _videoController!
                                                  .value.aspectRatio,
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                children: <Widget>[
                                                  VideoPlayer(
                                                      _videoController!),
                                                  ClosedCaption(
                                                      text: _videoController
                                                          ?.value.caption.text),
                                                  _ControlsOverlay(),
                                                  // VideoOverlayControllers(
                                                  //     controller: _controller!),
                                                  VideoProgressIndicator(
                                                      _videoController!,
                                                      allowScrubbing: true),
                                                ],
                                              ),
                                            ),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.black26,
                                            child: IconButton(
                                              onPressed: () {
                                                _postController.clearVideo();
                                              },
                                              icon: Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                              )
                            : _postController.isVideoPickedLoading == true
                                ? const Center(
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                // : Image.asset(
                                //     AppAssets.dummyPostImg,
                                //   ),
                                : Container(
                                    height: 200,
                                    width: double.infinity,
                                  ),
                    SizedBox(
                      height: 30,
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
                                    // locate.LocationData _locationData;
                                    // _locationData =
                                    //     await location.getLocation();
                                    // List<Placemark> placemarks =
                                    //     await placemarkFromCoordinates(
                                    //         _locationData.latitude!,
                                    //         _locationData.longitude!);

                                    print('click on post create button...');
                                    final isValid =
                                        _formKey.currentState!.validate();
                                    if (!isValid) return;
                                    setState(() {
                                      isPostButtonClicked = false;
                                    });
                                    final QuerySnapshot qSnap =
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .get();
                                    _postController.updateIsLoading(true);
                                    final int documentsLength =
                                        qSnap.docs.length;

                                    String imageURL = '';
                                    String videoURL = '';
                                    User? user =
                                        FirebaseAuth.instance.currentUser;

                                    /// For image
                                    if (_postController
                                        .pickedImage.value.path.isNotEmpty) {
                                      Timestamp timeStamp = Timestamp.now();

                                      /// Create a Reference to the file
                                      Reference storageRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('posts')
                                          .child(
                                              '/post${timeStamp}.${user?.uid}');

                                      /// upload the image
                                      UploadTask uploadTask = storageRef
                                          .putFile(File(_postController
                                              .pickedImage.value.path));
                                      await Future.value(uploadTask);
                                      imageURL =
                                          await storageRef.getDownloadURL();

                                      /// Now update the user object inside firestore and put the url of new uploaded image
                                      // FirebaseFirestore.instance.collection('posts').doc().update(
                                      //     {
                                      //       'profileImage': newURL.toString()
                                      //     }
                                      // ).then((value) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('user updated successfully'),),);
                                      // }).onError((error, stackTrace) {
                                      //   // Utils.showSnackBar("User not updated", Colors.black);
                                      // });
                                    }

                                    /// For video
                                    if (_postController
                                        .pickedVideo.value.path.isNotEmpty) {
                                      Timestamp timeStamp = Timestamp.now();

                                      /// Create a Reference to the file
                                      Reference storageRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('videos')
                                          .child(
                                              '/video${timeStamp}.${user?.uid}');

                                      /// upload the image
                                      UploadTask uploadTask = storageRef
                                          .putFile(File(_postController
                                              .pickedVideo.value.path));
                                      await Future.value(uploadTask);
                                      videoURL =
                                          await storageRef.getDownloadURL();
                                    }
                                    // print('image url value: ${imageURL}');
                                    // print('video url value: ${videoURL}');

                                    PostModel postModel = PostModel(
                                      id: documentsLength + 1,
                                      uid: AuthServices().user?.uid.toString(),
                                      createdAt: Timestamp.now(),
                                      postDescription: _descriptionController
                                          .text
                                          .toString(),
                                      postType: _postController
                                              .pickedVideo.value.path.isNotEmpty
                                          ? 'videoPost'
                                          : 'imagePost',
                                      likes: [],
                                      dislikes: [],
                                      comments: [],
                                      shares: [],
                                      postAddress: '',
                                      // postAddress:
                                      //     '${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}',
                                      postImage: imageURL.isNotEmpty
                                          ? imageURL
                                          : videoURL,
                                    );
                                    print(
                                        'post model before posting: ${postModel}');
                                    _createPostController
                                        .createPost(postModel)
                                        .then((value) {
                                      _postController.clearImage();
                                      _postController.clearVideo();
                                      _postController.clearUncompressedVideo();
                                      _postController.updateIsLoading(false);
                                    }).onError(
                                      (error, stackTrace) => _postController
                                          .updateIsLoading(false),
                                    );
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
          );
        }),
      ),
    );
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
  _ControlsOverlay() {
    /// check if the video is mute or not
    final isMuted = _videoController?.value.volume == 0;
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          reverseDuration: const Duration(milliseconds: 100),
          child: _videoController!.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black45,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 20,
                      child: Icon(
                        _videoController!.value.isPlaying
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
            _videoController!.value.isPlaying
                ? _videoController?.pause()
                : _videoController?.play();
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
            initialValue: _videoController?.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              _videoController?.setPlaybackSpeed(speed);
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
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    '${_videoController?.value.playbackSpeed}x',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
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
                  _videoController?.setVolume(isMuted ? 1 : 0);
                  setState(() {});
                }),
          ),
        ),
      ],
    );
  }
}
