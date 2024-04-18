import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/controller/dashboard_controller.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/screens/dashboard/screen/arena_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/chat/chat_main_page.dart';
import 'package:vip_connect/screens/dashboard/screen/profile_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/vip_module/vip_screen.dart';

import '../../controller/create_post_controller.dart';
import '../../helper/app_colors.dart';
import '../../services/create_post_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Widget> buildScreens = [
    ArenaScreen(),
    // ChatsScreen(),
    ChatMainScreen(),
    Container(),
    VipScreen(),
    ProfileScreen(),
  ];

  List<String> svgLists = [
    AppAssets.maskGroup3Svg,
    AppAssets.messageSvg,
    AppAssets.addSquareSvg,
    AppAssets.maskGroup4Svg,
    AppAssets.menuSvg,
  ];
  final createPostController = Get.put(CreatePostController());
  final postFirestore = PostsFirestoreDatebase();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createPostController.getPostsFirestore();
    postFirestore.getAllPostsData().then((posts) {
      List<dynamic> dynamicPosts = posts;
      dynamicPosts.forEach((post) {
        createPostController.getUserModelForPost(post['uid']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SignUpUserInfoController signUpUserInfoController =
        Provider.of<SignUpUserInfoController>(context);
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return WillPopScope(
        onWillPop: () async {
          if (dashboardController.currentIndex.value != 0) {
            dashboardController.updateCurrentIndex(0);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.secondary,
          body: SafeArea(
            child: IndexedStack(
              index: dashboardController.currentIndex.value,
              children: buildScreens,
            ),
          ),
          // body: Navigator(
          //   onGenerateRoute: (RouteSettings settings) {
          //     return MaterialPageRoute(
          //         builder: (_) => buildScreens.elementAt(
          //               dashboardController.currentIndex.value,
          //             ));
          //   },
          // ),
          bottomNavigationBar: Container(
            height: 82.h,
            width: double.infinity,
            // padding: EdgeInsets.only(right: 18.w, bottom: 30.h),
            decoration: BoxDecoration(
              color: AppColors.black800,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: svgLists.map((e) {
                int index = svgLists.indexOf(e);
                return InkWell(
                  onTap: () {
                    dashboardController.updateCurrentIndex(index);
                    if (signUpUserInfoController.videoController != null) {
                      if (signUpUserInfoController
                          .videoController!.value.isPlaying) {
                        signUpUserInfoController.videoController?.pause();
                      }
                    }
                    // Future.delayed(Duration(seconds: 1), () {
                    //   Navigator.pop(context);
                    // });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SvgPicture.asset(
                    svgLists[index],
                    color: dashboardController.currentIndex.value == index
                        ? AppColors.primary
                        : AppColors.white500,
                    height: 24.h,
                    width: 24.w,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
