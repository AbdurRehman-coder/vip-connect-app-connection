// import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:vip_connect/helper/app_colors.dart';

class PostController extends GetxController {
  RxBool isLoading = false.obs;
  updateIsLoading(bool value) {
    isLoading.value = value;
    update();
  }

  /// showing loading before video preview
  RxBool isVideoPickedLoading = false.obs;
  updateIsVideoLoading(bool value) {
    isVideoPickedLoading.value = value;
    update();
  }

  RxBool isLiked = false.obs;
  RxList<int> isLikedIndex = <int>[].obs;
  RxList<int> isDisLikedIndex = <int>[].obs;
  RxBool isDisLiked = false.obs;

  setLiked(int index) {
    isLiked.value = !isLiked.value;
    bool isSelected = isLikedIndex.value.contains(index);
    isSelected
        ? isLikedIndex.value.remove(index)
        : isLikedIndex.value.add(index);
    update();
  }

  setDisLiked(int index) {
    isDisLiked.value = !isDisLiked.value;
    bool isSelected = isDisLikedIndex.value.contains(index);
    isSelected
        ? isDisLikedIndex.value.remove(index)
        : isDisLikedIndex.value.add(index);
    update();
  }

  /// Image picker from gallery and camera
  final picker = ImagePicker();

  /// Document for document post
  Rx<XFile> pickedDocument = XFile('').obs;
  // XFile? get userImage.obx => _image;
  setDocument(XFile doc) {
    print('document setted: ${doc.path}');
    pickedDocument.value = doc;
    // update();
    // notifyListeners();
  }

  clearDocument() {
    pickedDocument.value = XFile('');
  }

  clearImage() {
    pickedImage.value = XFile('');
    articlePickedImage.value = XFile('');
  }

  clearVideo() {
    pickedVideo.value = File('');
  }

  clearUncompressedVideo() {
    pickedWithoutCompressVideo.value = File('');
  }

  /// Image post
  Rx<XFile> pickedImage = XFile('').obs;
  // XFile? get userImage.obx => _image;
  setUserImage(XFile image) {
    print('image setted: ${image.path}');
    pickedImage.value = image;
    clearVideo();
    // update();
    // notifyListeners();
  }

  /// Image Post
  Future getPostImageFromGallery() async {
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      setUserImage(XFile(imagePicker.path));
    }
    // updateIsLoading(true);
  }

  Future getPostImageFromCamera() async {
    final imagePicker = await picker.pickImage(source: ImageSource.camera);
    if (imagePicker != null) {
      setUserImage(XFile(imagePicker.path));
    }
  }

  /// Article Post image
  Rx<XFile> articlePickedImage = XFile('').obs;

  setArticleImage(XFile image) {
    print('article image setted: ${image.path}');
    articlePickedImage.value = image;
    clearVideo();
    // update();
    // notifyListeners();
  }

  /// Article Post Image
  Future getArticleImageFromGallery() async {
    final imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      setArticleImage(XFile(imagePicker.path));
    }
    // updateIsLoading(true);
  }

  Future getArticleImageFromCamera() async {
    final imagePicker = await picker.pickImage(source: ImageSource.camera);
    if (imagePicker != null) {
      setArticleImage(XFile(imagePicker.path));
    }
  }

  /// Get document from device using file_picker
  Future getDocumentFromDevice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png']);

    if (result != null) {
      // setUserImage(XFile(result.path));
      PlatformFile platformFile = result.files.first;
      XFile file = XFile(result.files.single.path.toString());

      // print('file name: ${platformFile.name}');
      // print('file path: ${platformFile.path?.replaceAll('docx', 'pdf')}');
      // print('file path: ${platformFile.path}');
      // print('file extension: ${platformFile.extension}');
      if (platformFile.extension == 'pdf') {
        print('this is pdf file');
        setDocument(file);
      } else {
        print('this is not pdf file convet to it');
        XFile convertFile = XFile(file.path.split('.').last);
        setDocument(XFile(
            file.path..replaceAll('docx', 'pdf').replaceAll('doc', 'pdf')));
        // _convertImageToPDF(file);
        // _convertDocxToPDF(file.path);
      }
    }
  }

  void chooseImageDestination({bool articlePost = false}) {
    BuildContext? getContext = Get.context;
    showDialog(
        context: getContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            content: Container(
              height: 150.h,
              decoration: BoxDecoration(
                // color: AppColors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '      Select image from: ',
                    style: TextStyle(color: Colors.black),
                  ),
                  ListTile(
                    onTap: () {
                      if (articlePost == true) {
                        getArticleImageFromCamera();
                      } else {
                        getPostImageFromCamera();
                      }
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      if (articlePost == true) {
                        getArticleImageFromGallery();
                      } else {
                        getPostImageFromGallery();
                      }
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// -----------------------------------------------

  /// Select Video
  Rx<File> pickedWithoutCompressVideo = File('').obs;
  Rx<File> pickedVideo = File('').obs;
  // XFile? get userImage.obx => _image;
  setUserVideo(File video) async {
    updateIsVideoLoading(true);
    pickedWithoutCompressVideo.value = video;
    // pickedVideo.value = video;

    /// Get the origina file size
    String pickedFileSize = await getFileSize(video.path, 1);

    /// Compress the video
    Future.delayed(Duration(seconds: 3), () async {
      final mediaInfo = await compressVideo(video);
      if (mediaInfo?.path != null) {
        String pickedFileSizeCompress =
            await getFileSize(mediaInfo!.path.toString(), 1);
        clearVideo();
        pickedVideo.value = mediaInfo.file!;
        updateIsVideoLoading(false);
        print('picked file size compress: ${pickedFileSizeCompress}');
      }
      print('picked file size1: $pickedFileSize');
      print('picked file size2: ${mediaInfo?.toJson()}');
    });

    // Future.delayed(Duration(seconds: 2), () async {
    //
    //   // await VideoCompress.deleteAllCache();
    // });

    clearImage();
    update();
    // notifyListeners();
  }

  /// Find Video File Size
  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  /// Compress the video in MediumQuality
  Future<MediaInfo?> compressVideo(File videoFile) async {
    final info = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    print('picked file size compress inside: ${info?.toJson()}');

    return info;
  }

  Future getProfileVideoFromGallery() async {
    final videoPicker = await picker.pickVideo(source: ImageSource.gallery);
    if (videoPicker != null) {
      setUserVideo(File(videoPicker.path));
    }
  }

  Future getProfileVideoFromCamera() async {
    final videoPicker = await picker.pickVideo(source: ImageSource.camera);
    if (videoPicker != null) {
      setUserVideo(File(videoPicker.path));
    }
  }

  void chooseVideoDestination() {
    BuildContext? getContext = Get.context;
    showDialog(
        context: getContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            content: Container(
              height: 150.h,
              decoration: BoxDecoration(
                // color: AppColors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '      Select video from: ',
                    style: TextStyle(color: Colors.black),
                  ),
                  ListTile(
                    onTap: () {
                      /// choose video from camera
                      getProfileVideoFromCamera();
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      /// choose video from gallery
                      getProfileVideoFromGallery();
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Rx<List<CustomPost>> selectedCustomPosts = [].obs as Rx<List<CustomPost>>;
  // void selectPost(CustomPost value) {
  //   final isSelected = selectedCustomPosts.value.contains(value);
  //   isSelected ?  selectedCustomPosts.value.remove(value)
  //       : selectedCustomPosts.value.add(value);
  // }
}
