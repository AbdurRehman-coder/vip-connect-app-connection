import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/controller/chat_controller.dart';

import '../../../../constants.dart';
import '../../../../helper/app_assets.dart';
import '../../../../helper/app_colors.dart';
import '../../../../helper/app_text_styles.dart';
import '../../../components/spacer.dart';

class ImageMessageScreen extends StatefulWidget {
  const ImageMessageScreen({Key? key}) : super(key: key);

  @override
  State<ImageMessageScreen> createState() => _ImageMessageScreenState();
}

class _ImageMessageScreenState extends State<ImageMessageScreen> {
  TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text(
          'image',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 30.h),
            _chatController.pickedImage.value.path.isNotEmpty
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                          // borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                        File(_chatController.pickedImage.value.path),
                        fit: BoxFit.fitHeight,
                      )),
                      CircleAvatar(
                        backgroundColor: Colors.black26,
                        child: IconButton(
                          onPressed: () {
                            // _chatController.clearImage();
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    height: 200.h,
                    width: double.infinity,
                  ),
            SizedBox(
              height: 10,
            ),

            /// Message TextField
            Expanded(
              child: Container(
                // height: 94.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.black800,
                  borderRadius: BorderRadius.circular(kBorderRadius16),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 17.w, vertical: 23.h),
                  child: TextFormField(
                    controller: _messageController,
                    maxLines: 1,
                    validator: (value) {
                      if (value!.length < 2) {
                        return ' Please enter your message';
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
                      hintText: ' Write your message...',
                      suffixIcon: Container(
                        color: Colors.grey.shade200,
                        child: InkWell(
                          onTap: () {
                            User? currentUser =
                                FirebaseAuth.instance.currentUser;
                            String senderId = currentUser!.uid;
                            // String user2Id = user2UID;
                            /// generate the chat room ID
                            // String chatRoomId =
                            //     generateChatRoomId(senderId, user2UID);

                            String messageText = _messageController.text;
                            // _scrollController.animateTo(
                            //   _scrollController
                            //       .position.maxScrollExtent,
                            //   duration:
                            //   Duration(milliseconds: 300),
                            //   curve: Curves.easeInOut,
                            // );

                            /// Pass data to firestore messages [Collection] inside chat_room [collection].
                            // ChatServices()
                            //     .sendMessage(
                            //         chatRoomId: chatRoomId,
                            //         senderId: senderId,
                            //         receiverId: user2UID,
                            //         messageText: messageText,
                            //         type: 'chat')
                            //     .then((value) {});

                            /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                            /// next screen
                            FocusScope.of(context).unfocus();
                            _messageController.clear();
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

                              //   },
                              //   child: SvgPicture.asset(
                              //     AppAssets.imageSvg,
                              //     color: AppColors.icons1,
                              //     height: 18.h,
                              //     width: 10.w,
                              //   ),
                              // ),
                              HorizontalSpacer(width: 10.w),
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
        );
      }),
    );
  }
}
