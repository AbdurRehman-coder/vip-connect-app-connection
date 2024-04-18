import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/model/chat_model.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/spacer.dart';
import 'package:vip_connect/services/chat_services.dart';

import '../../../../controller/post_controller.dart';
import '../../../../controller/user_profile_controller.dart';
import '../../../../main.dart';
import '../../../../model/user_model.dart';
import '../../../../services/firebase_auth.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _messageController = TextEditingController();
  final UserProfileController _profileController =
      Get.put(UserProfileController());
  final PostController _postController = Get.find();
  // final ChatController _chatController = Get.put(ChatController());

  final formKey = GlobalKey<FormState>();
  User currentUser = AuthServices().user!;
  ChatServices _chatServices = ChatServices();
  UserModel? currentUserModel;
  UserModel? receiverUserModel;
  final arguments = Get.arguments;
  String user2UID = '';
  String usersGeneratedIds = '';
  final ScrollController _scrollController = ScrollController();

  Stream<QuerySnapshot>? chatSnapshot;
  bool isImageUpload = false;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _messagesSubscription;

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
    user2UID = arguments['userID'];
    usersGeneratedIds = generateChatRoomId(currentUser.uid, user2UID);

    chatSnapshot = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(usersGeneratedIds)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();

    /// listen to messages status and update it to read, when user inside chat
    _messagesSubscription = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(usersGeneratedIds)
        .collection('messages')
        .where(
          'status',
          isEqualTo: 'unread',
        )
        .where('sender_id', isEqualTo: user2UID)
        .snapshots()
        .listen((querySnapshot) {
      final batch = FirebaseFirestore.instance.batch();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'status': 'read'});
      }
      // Finally, it commits the batch write operation to Firestore to update all the documents in a single batch.
      batch.commit();
    });
  }

  /// Get current user who will use this app and will show it before comment text field
  Future getUserData() async {
    /// Get sing user for posts
    final CollectionReference _userCollectionRef =
        FirebaseFirestore.instance.collection('user');

    /// Get current user
    DocumentSnapshot? docSnapshot =
        await _userCollectionRef.doc(currentUser.uid).get();
    UserModel user =
        UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

    /// Get receiver user for post
    DocumentSnapshot? user2Snap = await _userCollectionRef.doc(user2UID).get();
    UserModel user2Model =
        UserModel.fromJson(user2Snap.data() as Map<String, dynamic>);

    if (mounted) {
      setState(() {
        currentUserModel = user;
        receiverUserModel = user2Model;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messagesSubscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(title: AppTexts.chats),
        backgroundColor: AppColors.secondary,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // VerticalSpacer(height: 40.h),
              /// Post Showing that we comment on
              SizedBox(
                height: 40,
                width: double.infinity,
              ),
              StreamBuilder(
                  stream: chatSnapshot,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...");
                    }

                    /// converting firestore snapshot data into models
                    List<ChatModel> listMessageModel = [];

                    /// firstore snapshot data
                    snapshot.data?.docs
                        .forEach((DocumentSnapshot documentSnap) async {
                      ChatModel snapshotChatModel =
                          ChatModel.fromJson(documentSnap.data());
                      listMessageModel.add(snapshotChatModel);
                    });
                    snapshot.data?.docs.forEach((element) {});
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            // primary: false,
                            controller: _scrollController,
                            itemCount: listMessageModel.length,
                            itemBuilder: (context, index) {
                              ChatModel _chatModel = listMessageModel[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, top: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      _chatModel.senderId == currentUser.uid
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// Receiver user profile
                                        receiverUserModel?.uid ==
                                                _chatModel.senderId
                                            ? SizedBox(
                                                height: 42.h,
                                                width: 42.h,
                                                child: CircleAvatar(
                                                  /// User  picture inside post
                                                  child: receiverUserModel
                                                              ?.profileImage !=
                                                          null
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              receiverUserModel!
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
                                                                fit: BoxFit
                                                                    .cover,
                                                                // colorFilter:
                                                                // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CupertinoActivityIndicator()),
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
                                              )
                                            : Container(),
                                        const SizedBox(
                                          width: 05,
                                        ),

                                        /// Image message card
                                        _chatModel.chatType == 'image'
                                            ? Container(
                                                width: 200.w,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.black800,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // const SizedBox(height: 05),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: _chatModel
                                                            .imageURL
                                                            .toString(),
                                                        fit: BoxFit.contain,
                                                        // height: 180,
                                                        width: double.infinity,
                                                        progressIndicatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                string,
                                                                progress) {
                                                          // if (preg == null) return child;
                                                          return const Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        },
                                                        errorWidget: (context,
                                                            exception,
                                                            stackTrace) {
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
                                                      ),
                                                    ),
                                                    _chatModel.text != null ||
                                                            _chatModel.text !=
                                                                ''
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "${_chatModel.text} " ??
                                                                  "",
                                                              textAlign: _chatModel
                                                                          .senderId ==
                                                                      currentUser
                                                                          .uid
                                                                  ? TextAlign
                                                                      .right
                                                                  : TextAlign
                                                                      .left,
                                                              style: AppTextStyle
                                                                  .popping12_400,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              )

                                            /// Message card
                                            : Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 200.w),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  color: _chatModel.senderId ==
                                                          currentUser.uid
                                                      ? AppColors.blackHalfText
                                                      : AppColors.white500,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(14.r),
                                                    topLeft:
                                                        Radius.circular(14.r),
                                                    bottomRight: Radius
                                                        .circular(_chatModel
                                                                    .senderId ==
                                                                currentUser.uid
                                                            ? 0
                                                            : 14.r),
                                                    bottomLeft: Radius.circular(
                                                        _chatModel.senderId ==
                                                                currentUser.uid
                                                            ? 14.r
                                                            : 0.r),
                                                  ),
                                                ),
                                                child: Text(
                                                  listMessageModel[index]
                                                          .text ??
                                                      "",
                                                  textAlign:
                                                      _chatModel.senderId ==
                                                              currentUser.uid
                                                          ? TextAlign.right
                                                          : TextAlign.left,
                                                  style: AppTextStyle
                                                      .popping12_400,
                                                ),
                                              ),

                                        const SizedBox(
                                          width: 5,
                                        ),
                                        _chatModel.senderId == currentUser.uid

                                            /// Current user profile
                                            ? SizedBox(
                                                height: 42.h,
                                                width: 42.h,
                                                child: CircleAvatar(
                                                  /// User  picture inside post
                                                  child: currentUserModel
                                                              ?.profileImage !=
                                                          null
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              currentUserModel!
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
                                                                fit: BoxFit
                                                                    .cover,
                                                                // colorFilter:
                                                                // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CupertinoActivityIndicator()),
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
                                              )
                                            : Container(),
                                        HorizontalSpacer(width: 6.w),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    );
                  }),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5),
                  child: Form(
                    key: formKey,
                    child: Obx(() {
                      print(
                          'chat image: ${_postController.pickedImage.value.path}');
                      return Row(
                        children: [
                          SizedBox(
                            height: 42.h,
                            width: 42.h,
                            child: CircleAvatar(
                              /// User  picture inside post
                              child: currentUserModel?.profileImage != null
                                  ? CachedNetworkImage(
                                      imageUrl: currentUserModel!.profileImage
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
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
                          HorizontalSpacer(width: 6.w),

                          /// Message TextField
                          Expanded(
                            child: Container(
                              // height: 94.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.black800,
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius16),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 17.w, vertical: 23.h),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _postController.isLoading.value
                                        ? const Center(
                                            child: CupertinoActivityIndicator(
                                              color: Colors.white70,
                                            ),
                                          )
                                        : _postController.pickedImage.value.path
                                                .isNotEmpty
                                            ? Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 120,
                                                    width: 120,
                                                    child: ClipRRect(
                                                        // borderRadius: BorderRadius.circular(100),
                                                        child: Image.file(
                                                      File(_postController
                                                          .pickedImage
                                                          .value
                                                          .path),
                                                      fit: BoxFit.fitWidth,
                                                    )),
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black26,
                                                    radius: 14,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _postController
                                                            .clearImage();
                                                      },
                                                      icon: const Icon(
                                                        Icons.cancel_outlined,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(),

                                    /// Message TextField
                                    TextFormField(
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
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        hintStyle:
                                            AppTextStyle.bodyRegular.copyWith(
                                          fontSize: kFontSize12,
                                          color: AppColors.hintText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        hintText: ' Write your message...',
                                        suffixIcon: Container(
                                          color: Colors.grey.shade200,

                                          /// Message Send Button
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              GestureDetector(
                                                onTap: () {
                                                  /// Open dialog to show the two options [Camera, Gallery]
                                                  /// image widget
                                                  // _chatController
                                                  //     .chooseMessageImageDestination();
                                                  _postController
                                                      .chooseImageDestination();
                                                },
                                                child: SvgPicture.asset(
                                                  AppAssets.imageSvg,
                                                  color: AppColors.icons1,
                                                  height: 18.h,
                                                  width: 10.w,
                                                ),
                                              ),
                                              HorizontalSpacer(width: 10.w),
                                              InkWell(
                                                onTap: () async {
                                                  // _postController
                                                  //     .updateIsLoading(true);
                                                  setState(() {
                                                    isImageUpload = true;
                                                  });
                                                  String senderId =
                                                      currentUser.uid;
                                                  String imageURL = '';

                                                  /// For image
                                                  if (_postController
                                                          .pickedImage
                                                          .value
                                                          .path
                                                          .isNotEmpty &&
                                                      isImageUpload == true) {
                                                    _postController
                                                        .updateIsLoading(true);
                                                    setState(() {
                                                      isImageUpload = false;
                                                    });

                                                    /// For Image message pluse image
                                                    Timestamp timeStamp =
                                                        Timestamp.now();

                                                    /// Create a Reference to the file
                                                    Reference storageRef =
                                                        FirebaseStorage.instance
                                                            .ref()
                                                            .child('chats')
                                                            .child(
                                                                '/chat${timeStamp}.${user?.uid}');

                                                    /// upload the image
                                                    UploadTask uploadTask =
                                                        storageRef.putFile(File(
                                                            _postController
                                                                .pickedImage
                                                                .value
                                                                .path));
                                                    await Future.value(
                                                        uploadTask);

                                                    imageURL = await storageRef
                                                        .getDownloadURL();

                                                    /// pass data to firestore it its type is image
                                                    /// generate the chat room ID
                                                    String chatRoomId =
                                                        generateChatRoomId(
                                                            senderId, user2UID);

                                                    String messageText =
                                                        _messageController.text;

                                                    /// Pass data to firestore messages [Collection] inside chat_room [collection].
                                                    ChatServices()
                                                        .sendMessage(
                                                      chatRoomId: chatRoomId,
                                                      senderId: senderId,
                                                      receiverId: user2UID,
                                                      messageText: messageText,
                                                      type: 'chat',
                                                      chatType: 'image',
                                                      imageURL: imageURL,
                                                    )
                                                        .then((value) {
                                                      _postController
                                                          .clearImage();
                                                      _postController
                                                          .updateIsLoading(
                                                              false);

                                                      /// animate to the last message in chat list
                                                      _scrollController
                                                          .animateTo(
                                                        _scrollController
                                                            .position
                                                            .maxScrollExtent,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.easeInOut,
                                                      );
                                                    }).onError((error,
                                                                stackTrace) =>
                                                            _postController
                                                                .updateIsLoading(
                                                                    false));
                                                  } else {
                                                    /// For Text Messages
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      /// generate the chat room ID
                                                      String chatRoomId =
                                                          generateChatRoomId(
                                                              senderId,
                                                              user2UID);

                                                      String messageText =
                                                          _messageController
                                                              .text;

                                                      /// Pass data to firestore messages [Collection] inside chat_room [collection].
                                                      ChatServices()
                                                          .sendMessage(
                                                        chatRoomId: chatRoomId,
                                                        senderId: senderId,
                                                        receiverId: user2UID,
                                                        messageText:
                                                            messageText,
                                                        type: 'chat',
                                                        chatType: 'text',
                                                        imageURL: '',
                                                      )
                                                          .then((value) {
                                                        _scrollController
                                                            .animateTo(
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                      });

                                                      _postController
                                                          .updateIsLoading(
                                                              false);
                                                    } else {}
                                                  }

                                                  /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                                                  /// next screen
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  _messageController.clear();
                                                },
                                                child: SvgPicture.asset(
                                                  AppAssets.sendSvg,
                                                  color: AppColors.icons1,
                                                  height: 14.h,
                                                  width: 18.w,
                                                ),
                                              ),
                                              // HorizontalSpacer(width: 20.w),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String generateChatRoomId(String user1Id, String user2Id) {
    List<String> userIds = [user1Id, user2Id]..sort();
    return "${userIds[0]}-${userIds[1]}";
  }
}

