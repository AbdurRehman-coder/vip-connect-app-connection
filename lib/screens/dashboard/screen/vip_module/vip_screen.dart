import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/vip_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';
import 'package:vip_connect/services/vip_connection_services.dart';

import '../../../../model/user_model.dart';
import '../../../../services/firebase_auth.dart';
import '../../../../utils/util.dart';
import '../../../components/common_button.dart';

class VipScreen extends StatefulWidget {
  const VipScreen({Key? key}) : super(key: key);

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  Stream<QuerySnapshot>? _listOfUserStream;
  Stream<QuerySnapshot>? _searchUserListStream;
  TextEditingController _searchController = TextEditingController();
  String searchTerm = '';

  List<UserModel> _listUserModel = [];
  List<UserModel> _listUserModelOnSearch = [];

  VipController _vipController = Get.put(VipController());

  /// create instance of ConnectionService()
  ConnectionService _connectionService = ConnectionService();

  @override
  void initState() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    // TODO: implement initState
    super.initState();
    _listOfUserStream = FirebaseFirestore.instance
        .collection("user")
        .where('uid', isNotEqualTo: currentUserUid)
        .snapshots();

    getUserListFromCollection();
  }

  getUserListFromCollection() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("user")
        .where('uid', isNotEqualTo: currentUserUid)
        .snapshots()
        .listen((userDocs) {
      _listUserModel.clear();
      userDocs.docs.forEach((user) {
        UserModel _user = UserModel.fromJson(user.data());
        _listUserModel.add(_user);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: AppTexts.vipConnections,
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
                      _listUserModelOnSearch = _listUserModel
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
      body: Obx(() {
        print('search character: ${_vipController.searchText.value}');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),

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
                            : _listUserModel.length,
                        itemBuilder: (context, index) {
                          var userModel = _searchController.text.isNotEmpty
                              ? _listUserModelOnSearch[index]
                              : _listUserModel[index];

                          // UserModel userModel = UserModel.fromJson(
                          //     document!.data() as Map<String, dynamic>);

                          final currentUser = AuthServices().user;

                          return InkWell(
                            onTap: () {
                              /// go to user detail screen [vip detail]
                              Get.toNamed(routeShowPostUserProfile,
                                  arguments: [userModel.uid.toString()]);
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
                                          child: userModel.profileImage != null
                                              ? CachedNetworkImage(
                                                  imageUrl: userModel
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
                                              userModel.firstName != null
                                                  ? '${userModel.firstName} ${userModel.lastName}'
                                                  : "Jonathan Cooper",
                                              style: AppTextStyle.bodyMedium,
                                              // style: AppTextStyle.bodyMedium.copyWith(
                                              //   fontSize: kFontSize11,
                                              //   fontWeight: FontWeight.w600,
                                              // ),
                                            ),

                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                /// Designation text
                                                Text(
                                                  userModel.jobTitle != null
                                                      ? '${userModel.jobTitle}'
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
                                                  userModel.employerName != null
                                                      ? ' @ ${userModel.employerName}'
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

                    /// User in GridView
                    : StreamBuilder<QuerySnapshot>(
                        stream: _listOfUserStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text(
                                'No user available...',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          print(
                              'user profile length: ${snapshot.data?.docs.length}');
                          return Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              // primary: true,
                              itemCount: snapshot.data!.docs.length,
                              scrollDirection: Axis.vertical,
                              // physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 153.w / 220.h,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 10.h,
                              ),
                              itemBuilder: (context, index) {
                                var document = snapshot.data?.docs[index];

                                UserModel userModel = UserModel.fromJson(
                                    document!.data() as Map<String, dynamic>);

                                // final connectionStatus =
                                //     await _connectionService
                                //         .getConnectionStatus(userModel);

                                final currentUser = AuthServices().user;

                                return StreamBuilder(
                                  stream: _connectionService
                                      .getConnectionStatusStream(userModel),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final connectionStatus = snapshot.data;
                                      print(
                                          'connection status:: $connectionStatus');

                                      if (connectionStatus == 'pending') {
                                        return InkWell(
                                          onTap: () {
                                            /// go to user detail screen [vip detail]
                                            Get.toNamed(routeVipDetailScreen,
                                                arguments: [
                                                  userModel.uid.toString(),
                                                  'pending'
                                                ]);
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: AppColors.black800,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadius11),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 100.h,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        AppAssets.bgImg,
                                                        height: 64.h,
                                                      ),
                                                      Positioned.fill(
                                                        top: 31.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.toNamed(
                                                                routeShowPostUserProfile,
                                                                arguments: [
                                                                  userModel.uid
                                                                      .toString()
                                                                ]);
                                                          },
                                                          child: Center(
                                                            child: Container(
                                                              height: 110.h,
                                                              width: 110.h,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: AppColors
                                                                    .white300,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .white300,
                                                                    width: 4.w),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
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
                                                                          .contain,

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
                                                                      .dummyPostImg,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      VerticalSpacer(
                                                          height: 4.h),

                                                      /// User name
                                                      Text(
                                                        '${userModel.firstName} ${userModel.lastName}',
                                                        maxLines: 2,
                                                        style: AppTextStyle
                                                            .popping14_600,
                                                      ),
                                                      VerticalSpacer(
                                                          height: 1.h),
                                                      Text(
                                                          userModel.employerName
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .popping12_400
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white70)),
                                                      VerticalSpacer(
                                                          height: 7.h),
                                                      Text(
                                                          userModel.jobTitle
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .popping12_400
                                                              .copyWith(
                                                            color:
                                                                Colors.white70,
                                                          )),
                                                      VerticalSpacer(
                                                          height: 7.h),

                                                      /// TODO: showing real location data
                                                      CustomSvgAndText(
                                                        title:
                                                            '${userModel.cityName}, ${userModel.stateName}',
                                                        svgPath: AppAssets
                                                            .locationSvg,
                                                        style: AppTextStyle
                                                            .popping12_300,
                                                      ),
                                                      // VerticalSpacer(height: 10.h),
                                                      // CustomSvgAndText(
                                                      //   title: "Music, Books Read, Music",
                                                      //   svgPath: AppAssets.musicSvg,
                                                      //   style: AppTextStyle.popping12_300,
                                                      // ),
                                                      VerticalSpacer(
                                                          height: 12.h),

                                                      /// VIP Connect button
                                                      CommonButton(
                                                        title: 'Pending',
                                                        iconData: '',
                                                        height: 26.h,
                                                        borderRadius:
                                                            kBorderRadius6,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        isFill: true,
                                                        bgColor:
                                                            AppColors.black800,
                                                        borderColor:
                                                            AppColors.primary,
                                                        isIconVisible: false,
                                                        style: AppTextStyle
                                                            .rubik12_600,
                                                        onPressed: () {
                                                          Util.showToast(
                                                              'Connection already sent');
                                                          print(
                                                              'current user: ${currentUser?.uid} ,, reciever id: ${userModel.uid}');

                                                          /// send connection request
                                                          // _connectionService
                                                          //     .sendConnectionRequest(
                                                          //         currentUser!
                                                          //             .uid,
                                                          //         userModel
                                                          //             .uid!);
                                                        },
                                                        iconColor: AppColors
                                                            .transparent,
                                                        buttonShouldDisable:
                                                            false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (connectionStatus ==
                                          'accepted') {
                                        return InkWell(
                                          onTap: () {
                                            /// go to user detail screen [vip detail]
                                            Get.toNamed(routeVipDetailScreen,
                                                arguments: [
                                                  userModel.uid.toString(),
                                                  'accepted'
                                                ]);
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: AppColors.black800,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadius11),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 100.h,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        AppAssets.bgImg,
                                                        height: 64.h,
                                                      ),
                                                      Positioned.fill(
                                                        top: 31.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.toNamed(
                                                                routeShowPostUserProfile,
                                                                arguments: [
                                                                  userModel.uid
                                                                      .toString()
                                                                ]);
                                                          },
                                                          child: Center(
                                                            child: Container(
                                                              height: 110.h,
                                                              width: 110.h,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: AppColors
                                                                    .white300,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .white300,
                                                                    width: 4.w),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
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
                                                                          .contain,

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
                                                                      .dummyPostImg,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      VerticalSpacer(
                                                          height: 4.h),

                                                      /// User name
                                                      Text(
                                                        '${userModel.firstName} ${userModel.lastName}',
                                                        maxLines: 2,
                                                        style: AppTextStyle
                                                            .popping14_600,
                                                      ),
                                                      VerticalSpacer(
                                                          height: 1.h),
                                                      Text(
                                                          userModel.employerName
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .popping12_400
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white70)),
                                                      VerticalSpacer(
                                                          height: 7.h),
                                                      Text(
                                                          userModel.jobTitle
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .popping12_400
                                                              .copyWith(
                                                            color:
                                                                Colors.white70,
                                                          )),
                                                      VerticalSpacer(
                                                          height: 7.h),

                                                      /// TODO: showing real location data
                                                      CustomSvgAndText(
                                                        title:
                                                            '${userModel.cityName}, ${userModel.stateName}',
                                                        svgPath: AppAssets
                                                            .locationSvg,
                                                        style: AppTextStyle
                                                            .popping12_300,
                                                      ),
                                                      // VerticalSpacer(height: 10.h),
                                                      // CustomSvgAndText(
                                                      //   title: "Music, Books Read, Music",
                                                      //   svgPath: AppAssets.musicSvg,
                                                      //   style: AppTextStyle.popping12_300,
                                                      // ),
                                                      VerticalSpacer(
                                                          height: 12.h),

                                                      /// VIP Connect button
                                                      CommonButton(
                                                        title: 'Friend',
                                                        iconData: '',
                                                        height: 26.h,
                                                        borderRadius:
                                                            kBorderRadius6,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        isFill: true,
                                                        bgColor:
                                                            AppColors.black800,
                                                        borderColor:
                                                            AppColors.primary,
                                                        isIconVisible: false,
                                                        style: AppTextStyle
                                                            .rubik12_600,
                                                        onPressed: () {
                                                          // Util.showToast(
                                                          //     'Connection already sent');

                                                          /// send connection request
                                                          // _connectionService
                                                          //     .sendConnectionRequest(
                                                          //         currentUser!
                                                          //             .uid,
                                                          //         userModel
                                                          //             .uid!);
                                                        },
                                                        iconColor: AppColors
                                                            .transparent,
                                                        buttonShouldDisable:
                                                            false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            /// go to user detail screen [vip detail]
                                            Get.toNamed(routeVipDetailScreen,
                                                arguments: [
                                                  userModel.uid.toString(),
                                                  'none'
                                                ]);
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: AppColors.black800,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadius11),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 100.h,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        AppAssets.bgImg,
                                                        height: 64.h,
                                                      ),
                                                      Positioned.fill(
                                                        top: 31.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.toNamed(
                                                                routeShowPostUserProfile,
                                                                arguments: [
                                                                  userModel.uid
                                                                      .toString()
                                                                ]);
                                                          },
                                                          child: Center(
                                                            child: Container(
                                                              height: 110.h,
                                                              width: 110.h,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: AppColors
                                                                    .white300,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .white300,
                                                                    width: 4.w),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
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
                                                                          .contain,

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
                                                                      .dummyPostImg,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      VerticalSpacer(
                                                          height: 4.h),

                                                      /// User name
                                                      Text(
                                                        '${userModel.firstName} ${userModel.lastName}',
                                                        maxLines: 2,
                                                        style: AppTextStyle
                                                            .popping14_600,
                                                      ),
                                                      VerticalSpacer(
                                                          height: 1.h),
                                                      Text(
                                                          userModel.employerName
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .popping12_400
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white70)),
                                                      VerticalSpacer(
                                                          height: 7.h),
                                                      Text(
                                                          userModel.jobTitle
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .popping12_400
                                                              .copyWith(
                                                            color:
                                                                Colors.white70,
                                                          )),
                                                      VerticalSpacer(
                                                          height: 7.h),

                                                      /// TODO: showing real location data
                                                      CustomSvgAndText(
                                                        title:
                                                            '${userModel.cityName}, ${userModel.stateName}',
                                                        svgPath: AppAssets
                                                            .locationSvg,
                                                        style: AppTextStyle
                                                            .popping12_300,
                                                      ),
                                                      // VerticalSpacer(height: 10.h),
                                                      // CustomSvgAndText(
                                                      //   title: "Music, Books Read, Music",
                                                      //   svgPath: AppAssets.musicSvg,
                                                      //   style: AppTextStyle.popping12_300,
                                                      // ),
                                                      VerticalSpacer(
                                                          height: 12.h),

                                                      /// VIP Connect button
                                                      CommonButton(
                                                        title: 'Connect',
                                                        iconData: '',
                                                        height: 26.h,
                                                        borderRadius:
                                                            kBorderRadius6,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        isFill: true,
                                                        bgColor:
                                                            AppColors.black800,
                                                        borderColor:
                                                            AppColors.primary,
                                                        isIconVisible: false,
                                                        style: AppTextStyle
                                                            .rubik12_600,
                                                        onPressed: () {
                                                          Util.showToast(
                                                              'Connection request sent...');

                                                          /// send connection request
                                                          _connectionService
                                                              .sendConnectionRequest(
                                                                  currentUser!
                                                                      .uid,
                                                                  userModel
                                                                      .uid!);
                                                        },
                                                        iconColor: AppColors
                                                            .transparent,
                                                        buttonShouldDisable:
                                                            false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                );

                                // : Container();
                              },
                            ),
                          );
                        },
                      ),
          ],
        );
      }),
    );
  }
}

class CustomIconAndText extends StatelessWidget {
  CustomIconAndText({
    Key? key,
    this.size,
    required this.title,
    required this.imagePath,
    required this.style,
  }) : super(key: key);
  String title, imagePath;
  TextStyle style;
  double? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadius6),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: size ?? 21.h,
            width: size ?? 21.w,
          ),
        ),
        HorizontalSpacer(width: 3.w),
        SizedBox(
          width: size != null ? null : 81.w,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class CustomSvgAndText extends StatelessWidget {
  CustomSvgAndText({
    Key? key,
    this.size,
    required this.title,
    required this.svgPath,
    required this.style,
  }) : super(key: key);
  String title, svgPath;
  TextStyle style;
  double? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SvgPicture.asset(
          svgPath,
          height: size ?? 18.h,
          width: size ?? 18.w,
        ),
        HorizontalSpacer(width: size != null ? 8.w : 3.w),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}
