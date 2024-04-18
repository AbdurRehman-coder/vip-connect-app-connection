import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/model/GroupChatModel.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/components/private_chat_badge_widget.dart';

import '../../../../config/routes.dart';
import '../../../../constants.dart';
import '../../../../helper/app_assets.dart';
import '../../../../helper/app_colors.dart';
import '../../../../helper/app_text_styles.dart';
import '../../../../helper/app_texts.dart';
import '../../../../services/firebase_auth.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/spacer.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  TextEditingController _searchController = TextEditingController();

  List<String> groupChatLastMessage = [];

  Stream<QuerySnapshot>? _searchResultsStream;
  final currentUser = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot>? groupQuery;

  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('groupChat');

  List<GroupChatModel> publicGroups = [];
  List<GroupChatModel> privateGroups = [];

  /// for search
  List<UserModel> _friendsListUserModel = [];
  List<UserModel> _listUserModelOnSearch = [];

  @override
  void initState() {
    super.initState();

    getFriendListForSearch();

    _searchResultsStream =
        FirebaseFirestore.instance.collection("user").snapshots();

    // groupQuery =
    FirebaseFirestore.instance
        .collection('groupChat')
        .where('isPrivate', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        // .where('members', arrayContains: currentUser?.uid)
        .snapshots()
        .listen((event) {
      print('snapshot listen length: ${event.docs.length}');
    });
  }

  /// get all friends list user models
  getFriendListForSearch() {
    getFriendListStream().listen((userModels) {
      if (userModels.isNotEmpty) {
        setState(() {
          _friendsListUserModel.addAll(userModels);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('user model list--- ${_friendsListUserModel.length}');

    return Scaffold(
      appBar: customAppBar(
        title: 'Chat',
        hideBackButton: true,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 60.h),
          child: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 19.w),
            child: Column(
              children: [
                VerticalSpacer(height: 20.h),

                /// Search field
                CustomTextField(
                  controller: _searchController,
                  mainTitle: AppTexts.searchConnections,
                  hideMainTitle: true,
                  hintText: AppTexts.searchConnections,
                  hintTextStyle: AppTextStyle.bodyRegular.copyWith(
                    color: AppColors.white500,
                  ),
                  filled: true,
                  fillColor: AppColors.primary,
                  prefixWidget: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: SvgPicture.asset(
                      AppAssets.maskGroup2Svg,
                      color: AppColors.secondary,
                      height: 24.h,
                      width: 24.h,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _listUserModelOnSearch = _friendsListUserModel
                          .where((element) => element.fullName!
                              .toLowerCase()
                              .contains(value!.toLowerCase()))
                          .toList();
                    });

                    // _vipController.setSearchText(value!.toLowerCase());

                    /// search user list
                    //   FirebaseFirestore.instance
                    //       .collection('users')
                    //       .where('firstName',
                    //           isLessThanOrEqualTo: value.toLowerCase())
                    //       // .where('firstName', isLessThan: searchTerm + 'z')
                    //       // .limit(10)
                    //       .snapshots()
                    //       .listen((event) {
                    //     print('searched user:::: ${event.docs.length}');
                    //   });
                  },
                  onSaved: (String? newValue) {},
                  validator: (String? value) {},
                ),
                VerticalSpacer(height: 4.h),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.secondary,
      body: SingleChildScrollView(
        child:

            /// Condition for search
            _searchController.text.isNotEmpty && _listUserModelOnSearch.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(left: 22.0),
                    child: Text(
                      'No results found... ',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                : _searchController.text.isNotEmpty

                    /// Show search result
                    ? ListView.builder(
                        shrinkWrap: true,
                        // primary: false,
                        itemCount: _searchController.text.isNotEmpty
                            ? _listUserModelOnSearch.length
                            : _friendsListUserModel.length,
                        itemBuilder: (context, index) {
                          var searchUserModel =
                              _searchController.text.isNotEmpty
                                  ? _listUserModelOnSearch[index]
                                  : _friendsListUserModel[index];

                          // UserModel userModel = UserModel.fromJson(
                          //     document!.data() as Map<String, dynamic>);

                          final currentUser = AuthServices().user;

                          return InkWell(
                            onTap: () {
                              /// go to user detail screen [vip detail]
                              // Get.toNamed(routeShowPostUserProfile,
                              //     arguments: [userModel.uid.toString()]);
                              /// go to that specific user chat room
                              Get.toNamed(routeMessage,
                                  arguments: {'userID': searchUserModel.uid});
                            },
                            child: Column(
                              children: [
                                /// User Profile
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 55.h,
                                        width: 55.h,
                                        child: CircleAvatar(
                                          /// User  picture inside post
                                          child: searchUserModel.profileImage !=
                                                  null
                                              ? CachedNetworkImage(
                                                  imageUrl: searchUserModel
                                                      .profileImage
                                                      .toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
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
                                                              CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    AppAssets.logoImg,
                                                  ),
                                                )
                                              : Image.asset(
                                                  AppAssets.logoImg,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// User name
                                            Text(
                                              searchUserModel.firstName != null
                                                  ? '${searchUserModel.firstName} ${searchUserModel.lastName}'
                                                  : "Jonathan Cooper",
                                              style: AppTextStyle.bodyMedium,
                                            ),

                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                /// Designation text
                                                Text(
                                                  searchUserModel.jobTitle !=
                                                          null
                                                      ? '${searchUserModel.jobTitle}'
                                                      : " ",
                                                  style: AppTextStyle.bodyMedium
                                                      .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.white54,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),

                                                /// Company name
                                                Text(
                                                  searchUserModel
                                                              .employerName !=
                                                          null
                                                      ? ' @ ${searchUserModel.employerName}'
                                                      : " ",
                                                  style: AppTextStyle.bodyMedium
                                                      .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.white54,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpacer(height: 26.h),
                          InkWell(
                            onTap: () {
                              Get.toNamed(routeNewGroup);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 56.h,
                                    height: 56.h,
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.black700,
                                      child: SvgPicture.asset(
                                        AppAssets.plusSvg,
                                        height: 24.h,
                                        width: 24.w,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  HorizontalSpacer(
                                    width: 17.w,
                                  ),
                                  Text(
                                    'Create New Channel',
                                    style: AppTextStyle.rubik12_600
                                        .copyWith(fontSize: kFontSize16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          VerticalSpacer(height: 13.h),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text(
                              'Channels',
                              style: AppTextStyle.rubik12_600
                                  .copyWith(fontSize: kFontSize20),
                            ),
                          ),
                          VerticalSpacer(height: 11.h),

                          /// ========== Group Chat ============= ///
                          StreamBuilder<List<QueryDocumentSnapshot>>(
                            stream: getGroups(),
                            // stream: groupQuery,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Text(
                                    'No Group Available',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }

                              print('snapshot stream data; ${snapshot.data}');
                              final groupDocs = snapshot.data;

                              // Build your UI using the groupDocs list
                              // For example, you can use a ListView.builder to display the list of group chats
                              return ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: groupDocs?.length,
                                itemBuilder: (context, index) {
                                  final groupDoc = groupDocs![index];
                                  final groupName = groupDoc['name'] as String;
                                  final groupImage =
                                      groupDoc['groupImage'] as String ?? '';
                                  bool isPrivate = groupDoc['isPrivate'];
                                  final groupLastMessage =
                                      groupDoc['lastMessage'] as String ?? '';

                                  return InkWell(
                                    onTap: () {
                                      Get.toNamed(routeGroupMessageScreen,
                                          arguments: {
                                            'groupId': groupDoc.id,
                                            'groupName': groupName
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 55.h,
                                            width: 55.h,
                                            child: CircleAvatar(
                                              /// User  picture inside post
                                              child: groupImage.isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          groupImage.toString(),
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
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                /// Group name
                                                Text(
                                                  groupName,
                                                  style:
                                                      AppTextStyle.bodyMedium,
                                                  // style: AppTextStyle.bodyMedium.copyWith(
                                                  //   fontSize: kFontSize11,
                                                  //   fontWeight: FontWeight.w600,
                                                  // ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                groupLastMessage.isNotEmpty
                                                    ? Text(
                                                        groupLastMessage,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppTextStyle
                                                            .bodyMedium
                                                            .copyWith(
                                                          fontSize: 12,
                                                          color: Colors.white54,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      )
                                                    : Container(),

                                                SizedBox(height: 3.h),
                                              ],
                                            ),
                                          ),
                                          isPrivate
                                              ? const Icon(
                                                  Icons.lock_outline,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.public,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          // StreamBuilder(
                          //   stream: FirebaseFirestore.instance
                          //       .collection('groupChat')
                          //       .snapshots(),
                          //   builder: (BuildContext context,
                          //       AsyncSnapshot<QuerySnapshot> snapshot) {
                          //     if (snapshot.hasError) {
                          //       return Text('Error: ${snapshot.error}');
                          //     }
                          //
                          //     if (!snapshot.hasData) {
                          //       return const Text('Loading...');
                          //     }
                          //
                          //     snapshot.data?.docs.forEach((doc) {
                          //       GroupChatModel group = GroupChatModel.fromJson(doc);
                          //
                          //       if (group.isPrivate == true) {
                          //         privateGroups.add(group);
                          //       } else if (group.isPrivate == false) {
                          //         publicGroups.add(group);
                          //       } else {
                          //         print('no groupChat available');
                          //       }
                          //     });
                          //
                          //     /// Sort the groups by timestamp
                          //     if (publicGroups.isNotEmpty) {
                          //       publicGroups
                          //           .sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
                          //     }
                          //     if (privateGroups.isNotEmpty) {
                          //       privateGroups
                          //           .sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
                          //     }
                          //     // Combine the two lists into one
                          //     List<GroupChatModel> allGroups = [
                          //       ...publicGroups,
                          //       ...privateGroups
                          //     ];
                          //
                          //     return ListView.builder(
                          //       itemCount: allGroups.length,
                          //       itemBuilder: (BuildContext context, int index) {
                          //         GroupChatModel group = allGroups[index];
                          //
                          //         return ListTile(
                          //           title: Text(group.name.toString()),
                          //           subtitle: Text(group.lastMessage.toString()),
                          //           trailing:
                          //               group.isPrivate == true ? Icon(Icons.lock) : null,
                          //           onTap: () {
                          //             // Navigate to the chat screen for this group
                          //           },
                          //         );
                          //       },
                          //     );
                          //   },
                          // ),

                          VerticalSpacer(height: 8.h),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text(
                              'Direct Message',
                              style: AppTextStyle.rubik12_600
                                  .copyWith(fontSize: kFontSize20),
                            ),
                          ),

                          /// Direct Messages
                          StreamBuilder<List<UserModel>>(
                            // stream: _searchResultsStream,
                            stream: getFriendListStream(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Text(
                                    'No user...',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }
                              print('friend list: ${snapshot.data?.length}');

                              return ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  final currentUser = AuthServices().user;
                                  UserModel userModel = snapshot.data![index];

                                  String chatRoomId = generateChatRoomId(
                                      currentUser?.uid != null
                                          ? currentUser!.uid.toString()
                                          : '',
                                      userModel.uid!);
                                  print('chat room id------ $chatRoomId');
                                  // UserModel userModel = UserModel.fromJson(
                                  //     document!.data() as Map<String, dynamic>);

                                  // print('userModel accepted connections: ${userModel.acceptedConnections?.contains()}');
                                  return currentUser?.uid != userModel.uid
                                      ? Column(
                                          children: [
                                            /// User Profile
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  print(
                                                      'chat room other user uid: ${userModel.uid},, current uid: ${currentUser?.uid}');

                                                  Get.toNamed(routeMessage,
                                                      arguments: {
                                                        'userID': userModel.uid
                                                      });
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 55.h,
                                                      width: 55.h,
                                                      child: CircleAvatar(
                                                        /// User  picture inside post
                                                        child: userModel
                                                                    .profileImage !=
                                                                null
                                                            ? CachedNetworkImage(
                                                                imageUrl: userModel
                                                                    .profileImage
                                                                    .toString(),
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                            CupertinoActivityIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  AppAssets
                                                                      .logoImg,
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                AppAssets
                                                                    .logoImg,
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          /// User name
                                                          Text(
                                                            userModel.firstName !=
                                                                    null
                                                                ? '${userModel.firstName} ${userModel.lastName}'
                                                                : "Jonathan Cooper",
                                                            style: AppTextStyle
                                                                .bodyMedium,
                                                            // style: AppTextStyle.bodyMedium.copyWith(
                                                            //   fontSize: kFontSize11,
                                                            //   fontWeight: FontWeight.w600,
                                                            // ),
                                                          ),

                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              /// Designation text
                                                              Text(
                                                                userModel.jobTitle !=
                                                                        null
                                                                    ? '${userModel.jobTitle}'
                                                                    : " ",
                                                                style: AppTextStyle
                                                                    .bodyMedium
                                                                    .copyWith(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              ),

                                                              /// Company name
                                                              Text(
                                                                userModel.employerName !=
                                                                        null
                                                                    ? ' @ ${userModel.employerName}'
                                                                    : " ",
                                                                style: AppTextStyle
                                                                    .bodyMedium
                                                                    .copyWith(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 3.h),
                                                        ],
                                                      ),
                                                    ),
                                                    ChatBadgeWidget(
                                                        chatRoomId: chatRoomId),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container();
                                },
                              );
                            },
                          ),
                        ],
                      ),
      ),
    );
  }

  /// get chat_room document id by passing current user id and receiver id
  String generateChatRoomId(String user1Id, String user2Id) {
    List<String> userIds = [user1Id, user2Id]..sort();
    return "${userIds[0]}-${userIds[1]}";
  }

  /// get group chat stream
  Stream<List<QueryDocumentSnapshot>> getGroups() async* {
    final CollectionReference groupsCollection =
        FirebaseFirestore.instance.collection('groupChat');
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    // Query for all public groups, ordered by timestamp
    final QuerySnapshot publicGroupsSnapshot = await groupsCollection
        .where('isPrivate', isEqualTo: false)
        // .orderBy('timestamp', descending: true)
        .get();

    // Query for all private groups that the current user is a member of, ordered by timestamp
    final QuerySnapshot privateGroupsSnapshot = await groupsCollection
        .where('isPrivate', isEqualTo: true)
        .where('members', arrayContains: currentUserID)
        // .orderBy('timestamp', descending: true)
        .get();

    // Combine the two snapshots
    final List<QueryDocumentSnapshot> allGroups = [
      ...publicGroupsSnapshot.docs,
      ...privateGroupsSnapshot.docs
    ];

    // Sort the combined list based on privacy status
    // allGroups.sort((a, b) => a['isPrivate'].compareTo(b['isPrivate']));

    // Yield the sorted list as a stream
    yield allGroups;

    // Listen for changes to the groups collection and update the stream
    final Stream<QuerySnapshot> snapshots = groupsCollection.snapshots();
    await for (final QuerySnapshot snapshot in snapshots) {
      // Re-query for all groups and update the stream
      final QuerySnapshot publicGroupsSnapshot = await groupsCollection
          .where('isPrivate', isEqualTo: false)
          // .orderBy('timestamp', descending: true)
          .get();
      final QuerySnapshot privateGroupsSnapshot = await groupsCollection
          .where('isPrivate', isEqualTo: true)
          .where('members', arrayContains: currentUserID)
          // .orderBy('timestamp', descending: true)
          .get();
      final List<QueryDocumentSnapshot> allGroups = [
        ...publicGroupsSnapshot.docs,
        ...privateGroupsSnapshot.docs
      ];
      // allGroups.sort((a, b) => a['isPrivate'].compareTo(b['isPrivate']));
      yield allGroups;
    }
  }

  Stream<List<UserModel>> getFriendListStream() {
    final userRef =
        FirebaseFirestore.instance.collection('user').doc(currentUser?.uid);

    return userRef.snapshots().asyncMap((doc) async {
      final List<dynamic>? friendUids = doc.data()?['acceptedConnections'];
      if (friendUids == null || friendUids.isEmpty) {
        return <UserModel>[];
      }

      final List<Future<UserModel?>> futures = friendUids
          .map((friendUid) => getUser(friendUid))
          .whereType<Future<UserModel?>>()
          .toList();

      final List<UserModel?> friends = await Future.wait(futures);
      return friends.whereType<UserModel>().toList();
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('user').doc(uid);
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      return UserModel.fromJson(userData!);
    }
    return null;
  }

  // Stream<List<UserModel>> getFriendsStream(String uid) {
  //   final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
  //   return userRef.snapshots().transform(
  //     StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, List<UserModel>>.fromHandlers(
  //       handleData: (snapshot, sink) {
  //         final data = snapshot.data();
  //         if (data != null && data.containsKey('acceptedConnections')) {
  //           final friendUids = List<String>.from(data['acceptedConnections']);
  //           final friendStreamList = friendUids.map((friendUid) => getUser(friendUid)).toList();
  //           final friendStream = StreamGroup.merge(friendStreamList);
  //           sink.addStream(friendStream);
  //         } else {
  //           sink.add([]);
  //         }
  //       },
  //     ),
  //   );
  // }
}
