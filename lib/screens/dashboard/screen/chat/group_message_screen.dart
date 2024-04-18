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
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/spacer.dart';
import 'package:vip_connect/services/chat_services.dart';

import '../../../../controller/post_controller.dart';
import '../../../../main.dart';
import '../../../../model/chat_model.dart';
import '../../../../model/user_model.dart';
import '../../../../services/firebase_auth.dart';

class GroupMessageScreen extends StatefulWidget {
  GroupMessageScreen({Key? key}) : super(key: key);

  @override
  State<GroupMessageScreen> createState() => _GroupMessageScreen();
}

class _GroupMessageScreen extends State<GroupMessageScreen> {
  final PostController _postController = Get.find();
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// User collection Reference
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('user');

  final formKey = GlobalKey<FormState>();
  User currentUser = AuthServices().user!;
  ChatServices _chatServices = ChatServices();
  UserModel? currentUserModel;

  final arguments = Get.arguments;
  String groupId = '';
  String groupName = '';

  late Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream;

  Map<String, UserModel> _usersMap = {};

  /// ListView ScrollController
  ScrollController? _scrollController;
  Stream<QuerySnapshot>? groupChatSnapshot;

  bool isImageUpload = false;

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    /// get the groupId that we passed from the previous screen
    groupId = arguments['groupId'];
    groupName = arguments['groupName'];

    groupChatSnapshot = FirebaseFirestore.instance
        .collection('groupChat')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();

    /// Set up the messages stream to listen for changes to the message collection.
    _messagesStream = firestore
        .collection('groupChat')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    print('group message group id: ${groupId},, $groupName');

    /// Set up a listener for the messages stream, to update the local message list when changes occur.
    firestore
        .collection('groupChat')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
      print('querey snapshot:: ${querySnapshot.docs.length}');

      /// Convert each document in the snapshot to a Message object and add it to the local message list.
      List<ChatModel> newMessages = [];
      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot
            in querySnapshot.docs) {
          Map<String, dynamic> data = documentSnapshot.data()!;
          ChatModel message = ChatModel(
            text: data['text'],
            timestamp: data['timestamp'],
            senderId: data['sender_id'],
          );
          print('add messaging to the list: ${message.text}');
          newMessages.add(message);
        }
      } else {}
      Future.delayed(Duration(seconds: 1), () {
        print('new messages length: ${newMessages.length}');
      });

      if (newMessages.isNotEmpty) {
        Map<String, UserModel> newUsersMap =
            await getUsersForMessages(newMessages);

        /// Update the local message and user maps.
        if (mounted) {
          setState(() {
            // _messages = newMessages;
            _usersMap = newUsersMap;
          });
        }
      } else {
        print('group message newUsersApp is empty...');
      }
    });
  }

  /// Get users for messages
  Future<Map<String, UserModel>> getUsersForMessages(
      List<ChatModel> messages) async {
    // Collect a set of all the unique sender IDs in the set of messages.
    Set<String?> senderIds =
        messages.map((message) => message.senderId).toSet();

    /// Query the users collection for all the user documents with matching sender IDs.
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('user')
        .where('uid', whereIn: senderIds.toList())
        .get();

    // Convert the documents to User objects and store them in a map, indexed by user ID.
    Map<String, UserModel> usersMap = {};
    querySnapshot.docs.forEach((documentSnapshot) {
      // UserModel userM = UserModel(
      //   id: documentSnapshot.data()['userId'],
      //   name: documentSnapshot.data()['name'],
      //   imageUrl: documentSnapshot.data()['imageUrl'],
      UserModel userM = UserModel.fromJson(documentSnapshot.data());
      // );
      usersMap[userM.uid!] = userM;
    });

    return usersMap;
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

    if (mounted) {
      setState(() {
        currentUserModel = user;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print('group chat screen called...');
    return Scaffold(
      appBar: customAppBar(title: groupName ?? ''),
      backgroundColor: AppColors.secondary,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // VerticalSpacer(height: 40.h),
          /// Post Showing that we comment on

          const SizedBox(
            height: 40,
            width: double.infinity,
          ),
          StreamBuilder(
              stream: groupChatSnapshot,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading...");
                }

                /// converting firestore snapshot data into models
                List<ChatModel> listMessageModel = [];

                /// firstore snapshot data
                snapshot.data?.docs
                    .forEach((DocumentSnapshot documentSnap) async {
                  /// Chat Model that we got from messages collections
                  ChatModel snapshotChatModel =
                      ChatModel.fromJson(documentSnap.data());
                  listMessageModel.add(snapshotChatModel);
                });
                // snapshot.data?.docs.forEach((element) {});

                return listMessageModel.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              controller: _scrollController,
                              // reverse: true,
                              itemCount: listMessageModel.length,
                              itemBuilder: (context, index) {
                                /// Get Sender ID id
                                ChatModel _chatModel = listMessageModel[index];
                                UserModel? _userModell =
                                    _usersMap[_chatModel.senderId];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        listMessageModel[index].senderId ==
                                                currentUser.uid
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /// Receiver user profile
                                          currentUser.uid !=
                                                  listMessageModel[index]
                                                      .senderId
                                              ? SizedBox(
                                                  height: 42.h,
                                                  width: 42.h,
                                                  child: CircleAvatar(
                                                    /// User  picture inside post
                                                    child: _userModell
                                                                ?.profileImage !=
                                                            null
                                                        ? CachedNetworkImage(
                                                            imageUrl:
                                                                _userModell!
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
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.black800,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // const SizedBox(height: 05),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: _chatModel
                                                              .imageURL
                                                              .toString(),
                                                          fit: BoxFit.contain,
                                                          // height: 180,
                                                          width:
                                                              double.infinity,
                                                          progressIndicatorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  string,
                                                                  progress) {
                                                            // if (preg == null) return child;
                                                            return const Center(
                                                              child:
                                                                  CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .white,
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
                                                    color:
                                                        listMessageModel[index]
                                                                    .senderId ==
                                                                currentUser.uid
                                                            ? AppColors
                                                                .blackHalfText
                                                            : AppColors
                                                                .white500,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(14.r),
                                                      topLeft:
                                                          Radius.circular(14.r),
                                                      bottomRight: Radius.circular(
                                                          listMessageModel[
                                                                          index]
                                                                      .senderId ==
                                                                  currentUser
                                                                      .uid
                                                              ? 0
                                                              : 14.r),
                                                      bottomLeft: Radius.circular(
                                                          listMessageModel[
                                                                          index]
                                                                      .senderId ==
                                                                  currentUser
                                                                      .uid
                                                              ? 14.r
                                                              : 0.r),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    listMessageModel[index]
                                                            .text ??
                                                        "",
                                                    textAlign:
                                                        listMessageModel[index]
                                                                    .senderId ==
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
                                          listMessageModel[index].senderId ==
                                                  currentUser.uid

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
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
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
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            'No Message...',
                            style: TextStyle(color: Colors.white70),
                          ),
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
                  return Row(
                    children: [
                      SizedBox(
                        height: 42.h,
                        width: 42.h,
                        child: CircleAvatar(
                          /// User  picture inside post
                          child: currentUserModel?.profileImage != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      currentUserModel!.profileImage.toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        // colorFilter:
                                        // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator()),
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
                          // height: 99.h,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _postController.isLoading.value
                                    ? const Center(
                                        child: CupertinoActivityIndicator(
                                          color: Colors.white70,
                                        ),
                                      )
                                    : _postController
                                            .pickedImage.value.path.isNotEmpty
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
                                                      .pickedImage.value.path),
                                                  fit: BoxFit.fitWidth,
                                                )),
                                              ),
                                              CircleAvatar(
                                                backgroundColor: Colors.black26,
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

                                /// message textfield
                                TextFormField(
                                  controller: _messageController,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.length < 2) {
                                      return 'Please enter a message';
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
                                    hintStyle:
                                        AppTextStyle.bodyRegular.copyWith(
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
                                    hintText: '  Write your message...',
                                    suffixIcon: Container(
                                      color: Colors.grey.shade200,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              /// Open dialog to show the two options [Camera, Gallery]
                                              /// image widget

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
                                              setState(() {
                                                isImageUpload = true;
                                              });
                                              String senderId = currentUser.uid;
                                              String imageURL = '';

                                              /// For image
                                              if (_postController.pickedImage
                                                      .value.path.isNotEmpty &&
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
                                                        .child('groupChat')
                                                        .child(
                                                            '/groupChat${timeStamp}.${user?.uid}');

                                                /// upload the image
                                                UploadTask uploadTask =
                                                    storageRef.putFile(File(
                                                        _postController
                                                            .pickedImage
                                                            .value
                                                            .path));
                                                await Future.value(uploadTask);

                                                imageURL = await storageRef
                                                    .getDownloadURL();

                                                String messageText =
                                                    _messageController.text;

                                                /// Pass data to firestore messages [Collection] inside chat_room [collection].
                                                ChatServices()
                                                    .sendMessageToGroup(
                                                  groupId: groupId,
                                                  senderId: FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid,
                                                  messageText:
                                                      _messageController.text,
                                                  type: 'groupChat',
                                                  chatType: 'image',
                                                  imageURL: imageURL,
                                                )
                                                    .then((value) {
                                                  _postController.clearImage();
                                                  _messageController.clear();
                                                  _postController
                                                      .updateIsLoading(false);
                                                  _scrollController?.animateTo(
                                                    _scrollController!.position
                                                        .maxScrollExtent,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeOut,
                                                  );
                                                }).onError((error, stackTrace) {
                                                  _postController.clearImage();
                                                  _postController
                                                      .updateIsLoading(false);
                                                });
                                              } else {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  /// Pass data to firestore messages [Collection] inside chat_room [collection].
                                                  ChatServices()
                                                      .sendMessageToGroup(
                                                    groupId: groupId,
                                                    senderId: FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid,
                                                    messageText:
                                                        _messageController.text,
                                                    type: 'groupChat',
                                                    chatType: 'text',
                                                    imageURL: '',
                                                  )
                                                      .then((value) {
                                                    _messageController.clear();
                                                    _scrollController
                                                        ?.animateTo(
                                                      _scrollController!
                                                          .position
                                                          .maxScrollExtent,
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeOut,
                                                    );
                                                  });

                                                  /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                                                  /// next screen
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  _messageController.clear();
                                                } else {}
                                              }
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

      /// body
      // body: SingleChildScrollView(
      //   padding: EdgeInsets.only(left: 20.w, right: 20.w),
      //   child: ListView.builder(
      //     physics: const NeverScrollableScrollPhysics(),
      //     shrinkWrap: true,
      //     itemCount: dummyMessageList.length,
      //     itemBuilder: (context, index) {
      //       return Align(
      //         alignment: dummyMessageList[index].from == "me"
      //             ? Alignment.centerRight
      //             : Alignment.centerLeft,
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: dummyMessageList[index].from == "me"
      //               ? CrossAxisAlignment.end
      //               : CrossAxisAlignment.start,
      //           children: [
      //             Container(
      //               constraints: BoxConstraints(maxWidth: 284.w),
      //               margin: EdgeInsets.symmetric(vertical: 4.h),
      //               padding:
      //                   EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      //               decoration: BoxDecoration(
      //                 color: dummyMessageList[index].from == "me"
      //                     ? AppColors.blackHalfText
      //                     : AppColors.white500,
      //                 borderRadius: BorderRadius.only(
      //                   topRight: Radius.circular(10.r),
      //                   topLeft: Radius.circular(10.r),
      //                   bottomRight: Radius.circular(
      //                       dummyMessageList[index].from == "me" ? 0 : 10.r),
      //                   bottomLeft: Radius.circular(
      //                       dummyMessageList[index].from == "me" ? 10.r : 0.r),
      //                 ),
      //               ),
      //               child: Text(
      //                 dummyMessageList[index].message ?? "",
      //                 textAlign: dummyMessageList[index].from == "me"
      //                     ? TextAlign.right
      //                     : TextAlign.left,
      //                 style: AppTextStyle.popping12_400,
      //               ),
      //             ),
      //             if (dummyMessageList.length > (index + 1)) ...{
      //               if (dummyMessageList[index].from == "me"
      //                   ? dummyMessageList[index + 1].from != "me"
      //                   : dummyMessageList[index + 1].from == "me")
      //                 Text(
      //                   "14:30",
      //                   textAlign: dummyMessageList[index].from == "me"
      //                       ? TextAlign.right
      //                       : TextAlign.left,
      //                   style: AppTextStyle.popping12_400
      //                       .copyWith(color: AppColors.white300),
      //                 ),
      //             } else ...{
      //               Text(
      //                 "14:30",
      //                 textAlign: dummyMessageList[index].from == "me"
      //                     ? TextAlign.right
      //                     : TextAlign.left,
      //                 style: AppTextStyle.popping12_400
      //                     .copyWith(color: AppColors.white300),
      //               ),
      //             }
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }

//   String generateChatRoomId(String user1Id, String user2Id) {
//     List<String> userIds = [user1Id, user2Id]..sort();
//     return "${userIds[0]}-${userIds[1]}";
//   }
// }
//
// class CustomChatListTile extends StatelessWidget {
//   CustomChatListTile({
//     Key? key,
//     required this.onTap,
//   }) : super(key: key);
//   VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6.h),
//       child: InkWell(
//         onTap: onTap,
//         child: Row(
//           children: [
//             SizedBox(
//               height: 66.h,
//               width: 66.h,
//               child: CircleAvatar(
//                 child: Image.asset(AppAssets.tempProfileImg),
//               ),
//             ),
//             HorizontalSpacer(width: 15.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Team Align",
//                     style: AppTextStyle.bodyMedium,
//                   ),
//                   VerticalSpacer(height: 5.h),
//                   Text(
//                     "Don’t miss to attend the meeting.",
//                     style: AppTextStyle.bodyRegular
//                         .copyWith(fontSize: kFontSize14),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 Text(
//                   "2 min ago",
//                   style: AppTextStyle.bodyRegular.copyWith(
//                     fontSize: kFontSize14,
//                   ),
//                 ),
//                 VerticalSpacer(height: 10.h),
//                 SizedBox(
//                   height: 22.h,
//                   width: 22.h,
//                   child: CircleAvatar(
//                     backgroundColor: AppColors.black400,
//                     child: Text(
//                       "3",
//                       style: AppTextStyle.bodyRegular.copyWith(
//                         fontSize: kFontSize13,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
}
