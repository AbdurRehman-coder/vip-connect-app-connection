import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/chat_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';
import 'package:vip_connect/services/firebase_auth.dart';

import '../../../../controller/user_profile_controller.dart';
import '../../../../services/chat_services.dart';

class NewGroupNameScreen extends StatefulWidget {
  const NewGroupNameScreen({Key? key}) : super(key: key);

  @override
  State<NewGroupNameScreen> createState() => _NewGroupNameScreenState();
}

class _NewGroupNameScreenState extends State<NewGroupNameScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController groupNameController = TextEditingController();
  ChatController _chatController = Get.find();
  final userProfileController = Get.put(UserProfileController());
  int chatGroupDocLength = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance.collection('groupChat').get().then((value) {
      chatGroupDocLength = value.docs.length;
      setState(() {});
    });
  }

  bool isPrivate = false;
  bool isLoading = false;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // appBar: customAppBar(title: AppTexts.newGroup),
          backgroundColor: AppColors.secondary,
          body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Obx(() {
              return Form(
                key: formKey,
                child: isLoading == true
                    ? const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 08,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: isLoading == false
                                    ? () async {
                                        // if (formKey.currentState!.validate()) {
                                        //   setState(() {
                                        //     isLoading = true;
                                        //   });
                                        // }
                                        String currentUserUID =
                                            AuthServices().user!.uid;

                                        /// To Hide the keyboard
                                        FocusScope.of(context).unfocus();
                                        String groupImageURL = '';
                                        if (userProfileController.pickedImage
                                            .value.path.isNotEmpty) {
                                          /// Create a Reference to the file
                                          Reference storageRef = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child('groupChat')
                                              .child(
                                                  '/groupImage${currentUserUID}-${groupNameController.text}');

                                          /// upload the image
                                          UploadTask uploadTask =
                                              storageRef.putFile(File(
                                                  userProfileController
                                                      .pickedImage.value.path));
                                          await Future.value(uploadTask);
                                          groupImageURL =
                                              await storageRef.getDownloadURL();
                                        }
                                        if (formKey.currentState!.validate()) {
                                          if (_chatController
                                              .selectedUserUIDs.isNotEmpty) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            _chatController.setSelectedUserUIDS(
                                                currentUserUID);

                                            /// Create Group Collection in firestore and create document for this group
                                            ChatServices()
                                                .createGroup(
                                                    groupName:
                                                        groupNameController
                                                            .text,
                                                    groupDescription: '',
                                                    groupOwnerId:
                                                        currentUserUID,
                                                    members: _chatController
                                                        .selectedUserUIDs,
                                                    groupImage: groupImageURL,
                                                    chatGroupDocLength:
                                                        chatGroupDocLength,
                                                    isPrivate: isPrivate)
                                                .then((value) {
                                              groupNameController.clear();
                                              userProfileController
                                                  .setUserImage(XFile(''));
                                              setState(() {
                                                isLoading = false;
                                              });
                                              Get.back();
                                              Get.back();
                                            }).onError((error, stackTrace) {
                                              print(
                                                  'error while creating groupChat: $error ,, $stackTrace');
                                              setState(() {
                                                isLoading = false;
                                              });
                                            });
                                          } else {
                                            // print('can not create empty group');
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Empty group can not be create",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                backgroundColor: Colors.red,
                                                fontSize: 16.0);
                                          }
                                        }
                                      }
                                    : () {},
                                child: const Text(
                                  'Create',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSpacer(height: 10.h),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      userProfileController
                                          .chooseProfileImageDestination();
                                    },
                                    child: Container(
                                      height: 75.h,
                                      width: 75.h,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.white300,
                                        border: Border.all(
                                            color: AppColors.white300,
                                            width: 4.w),
                                        // image: DecorationImage(
                                        //   image: AssetImage(
                                        //     // AppAssets.dummyPostImg,
                                        //     userProfileController.pickedImage.value.path
                                        //   ),
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                      child: userProfileController
                                              .pickedImage.value.path.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.file(
                                                File(userProfileController
                                                    .pickedImage.value.path),
                                                // imageProvider,
                                                height: 110.0,
                                                width: 110.0,
                                                fit: BoxFit.cover,
                                              ))
                                          : Image.asset(
                                              AppAssets.dummyPostImg,
                                            ),
                                      // child: CircleAvatar(
                                      //   backgroundColor: AppColors.white300,
                                      //   child: SvgPicture.asset(
                                      //     AppAssets.imageSvg,
                                      //     height: 32.h,
                                      //     width: 32.w,
                                      //     color: AppColors.randomColor2,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                  HorizontalSpacer(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppTexts.groupName,
                                          style:
                                              AppTextStyle.bodyRegular.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        VerticalSpacer(height: 8.h),
                                        CustomTextField(
                                          controller: groupNameController,
                                          mainTitle: AppTexts.typeGroupName,
                                          hideMainTitle: true,
                                          hintText: AppTexts.typeGroupName,
                                          hintTextStyle:
                                              AppTextStyle.bodyRegular.copyWith(
                                            color: AppColors.white500,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.primary,
                                          onSaved: (String? newValue) {},
                                          validator: (value) {
                                            if (value!.length < 2) {
                                              return 'Please enter a group name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              VerticalSpacer(height: 31.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Private Group",
                                    style: AppTextStyle.rubik12_600.copyWith(
                                      fontSize: kFontSize20,
                                    ),
                                  ),
                                  Switch(
                                    // thumb color (round icon)
                                    activeColor: Colors.amber,
                                    activeTrackColor: Colors.blue,
                                    inactiveThumbColor:
                                        Colors.blueGrey.shade600,
                                    inactiveTrackColor: Colors.grey.shade400,
                                    splashRadius: 50.0,
                                    // boolean variable value
                                    value: isPrivate,
                                    // changes the state of the switch
                                    onChanged: (value) =>
                                        setState(() => isPrivate = value),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "${AppTexts.participants} ${_chatController.userModelList.length}",
                                style: AppTextStyle.rubik12_600.copyWith(
                                  fontSize: kFontSize20,
                                ),
                              ),
                              VerticalSpacer(height: 17.h),
                              _chatController.userModelList.isNotEmpty
                                  ? Wrap(
                                      spacing: 16.w,
                                      runSpacing: 20.h,
                                      alignment: WrapAlignment.start,
                                      children: _chatController.userModelList
                                          .map((userModell) {
                                        return SizedBox(
                                          height: 70.h,
                                          width: 70.h,
                                          child: Stack(
                                            children: [
                                              // ClipOval(
                                              //   child: Image.network(e.profileImage.toString()),
                                              // ),
                                              userModell.profileImage != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: userModell
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
                                              Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _chatController
                                                          .removeUserModel(
                                                              userModell);
                                                      // selectedUsersIds.removeWhere(
                                                      //         (element) => element == userModell.uid);
                                                      setState(() {});
                                                    },
                                                    child: SizedBox(
                                                      height: 24.h,
                                                      width: 24.h,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.white,
                                                        child: SvgPicture.asset(
                                                          AppAssets.closeSvg,
                                                          color:
                                                              AppColors.black,
                                                          height: 14.h,
                                                          width: 14.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      // children: const [
                                      // CustomImageWithClose(),
                                      // CustomImageWithClose(),
                                      // CustomImageWithClose(),
                                      // CustomImageWithClose(),
                                      // CustomImageWithClose(),
                                      // CustomImageWithClose(),
                                      // ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
              );
            }),
          )),
    );
  }
}
