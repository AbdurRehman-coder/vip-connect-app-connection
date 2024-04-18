import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_connect/screens/authentication/forget_screen.dart';
import 'package:vip_connect/screens/authentication/login_screen.dart';
import 'package:vip_connect/screens/authentication/new_password_screen.dart';
import 'package:vip_connect/screens/authentication/otp_screen.dart';
import 'package:vip_connect/screens/authentication/sign_up_screen.dart';
import 'package:vip_connect/screens/authentication/verify_email_screen.dart';
import 'package:vip_connect/screens/dashboard/dashboard.dart';
import 'package:vip_connect/screens/dashboard/screen/chat/group_message_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/chat/message_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/chat/new_group_name_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/chat/new_group_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/notification/notification_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/profile_screen_subscreens/change_email_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/profile_screen_subscreens/change_password_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/profile_screen_subscreens/invite_friend_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/profile_screen_subscreens/privacy_policy_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/profile_screen_subscreens/update_profile_screen.dart';
import 'package:vip_connect/screens/dashboard/screen/vip_module/vip_detail_screen.dart';
import 'package:vip_connect/screens/onboarding/onboarding.dart';
import 'package:vip_connect/screens/post/create_poll_screen.dart';
import 'package:vip_connect/screens/post/post_comments_screen.dart';
import 'package:vip_connect/screens/post/post_edit_screen.dart';
import 'package:vip_connect/screens/post/publish_article_screen.dart';
import 'package:vip_connect/screens/post/share_post.dart';
import 'package:vip_connect/screens/web/dashboard_web.dart';
import 'package:vip_connect/screens/web/login_screen_web.dart';
import 'package:vip_connect/utils/keyboard_dismiss.dart';

import '../screens/authentication/delete_user_account_screen.dart';
import '../screens/dashboard/screen/chat/image_message_screen.dart';
import '../screens/dashboard/screen/profile_screen_subscreens/post_profile_screen.dart';
import '../screens/dashboard/screen/profile_screen_subscreens/show_user_profile_screen.dart';
import '../screens/post/create_document_post.dart';
import '../screens/splash/splash.dart';

const routeLoginWeb = '/routeLoginWeb';
const routeSplash = '/routeSplash';
const routeOnBoarding = '/routeOnBoarding';
const routeLogin = '/routeLogin';
const routeForgetPassword = '/routeForgetPassword';
const routeVerifyEmail = '/routeVerifyEmail';
const routeDeleteUserAccount = '/routeDeleteUserAccount';
const routeOtp = '/routeOtp';
const routeNewPassword = '/routeNewPassword';
const routeSignUp = '/routeSignUp';
const routeDashboard = '/routeDashboard';
const routeSharePost = '/routeSharePost';

const routeChangeEmail = '/routeChangeEmail';
const routeChangePassword = '/routeChangePassword';
const routeInviteFriend = '/routeInviteFriend';
const routePrivacyPolicy = '/routePrivacyPolicy';
const routeUpdateProfile = '/routeUpdateProfile';
const showUserProfile = '/showUserProfile';
const routeShowPostUserProfile = '/routeShowPostUserProfile';
const routeVipDetailScreen = '/routeVipDetailScreen';
const routeMessage = '/routeMessage';
const routeImageMessage = '/routeImageMessage';
const routeGroupMessageScreen = '/routeGroupMessageScreen';
const routeChatScreen = '/routeChatScreen';
const routeNewGroup = '/routeNewGroup';
const routeNewGroupName = '/routeNewGroupName';
const routeNotificationScreen = '/routeNotificationScreen';
const routeCommentPost = '/routeCommentPost';
const routeEditArenaPost = '/routeEditArenaPost';
const routePublicArticle = '/routePublicArticle';
const routeCreatePoll = '/routeCreatePoll';
const routeCreateDocumentScreen = '/routeCreateDocumentScreen';
const routeDashboardWeb = '/routeDashboardWeb';

class Routes {
  static final routes = [
    GetPage(name: routeSplash, page: () => TKDismiss(SplashScreen())),
    GetPage(name: routeOnBoarding, page: () => TKDismiss(OnBoardingScreen())),
    GetPage(name: routeLogin, page: () => TKDismiss(LoginScreen())),
    GetPage(
        name: routeForgetPassword,
        page: () => TKDismiss(ForgetPasswordScreen())),
    GetPage(name: routeVerifyEmail, page: () => TKDismiss(VerifyEmailScreen())),
    GetPage(
        name: routeDeleteUserAccount,
        page: () => TKDismiss(DeleteUserAccountScreen())),
    GetPage(name: routeOtp, page: () => const TKDismiss(OtpScreen())),
    // GetPage(
    //     name: routeNewPassword,
    //     page: () => const TKDismiss(NewPasswordScreen())),
    GetPage(name: routeSignUp, page: () => TKDismiss(SignUpScreen())),
    GetPage(name: routeDashboard, page: () => const TKDismiss(Dashboard())),
    GetPage(name: routeSharePost, page: () => TKDismiss(SharePostScreen())),

    GetPage(
        name: routeChangeEmail,
        page: () => const TKDismiss(ChangeEmailScreen())),
    GetPage(
        name: routeChangePassword,
        page: () => const TKDismiss(ChangePasswordScreen())),
    GetPage(
        name: routeInviteFriend,
        page: () => const TKDismiss(InviteFriendScreen())),
    GetPage(
        name: routePrivacyPolicy,
        page: () => const TKDismiss(PrivacyPolicyScreen())),
    GetPage(
        name: routeUpdateProfile, page: () => TKDismiss(UpdateProfileScreen())),
    GetPage(
        name: showUserProfile, page: () => TKDismiss(ShowUserProfileScreen())),
    GetPage(
        name: routeShowPostUserProfile,
        page: () => TKDismiss(ShowPostUserProfile())),
    GetPage(
        name: routeVipDetailScreen, page: () => TKDismiss(VipDetailScreen())),
    GetPage(name: routeMessage, page: () => TKDismiss(MessageScreen())),
    GetPage(
        name: routeImageMessage, page: () => TKDismiss(ImageMessageScreen())),
    GetPage(
        name: routeGroupMessageScreen,
        page: () => TKDismiss(GroupMessageScreen())),
    // GetPage(name: routeChatScreen, page: () => TKDismiss(ChatsScreen())),
    GetPage(name: routeNewGroup, page: () => const TKDismiss(NewGroupScreen())),
    GetPage(
        name: routeNewGroupName,
        page: () => const TKDismiss(NewGroupNameScreen())),
    GetPage(
      name: routeNotificationScreen,
      page: () => TKDismiss(
        NotificationScreen(),
      ),
    ),
    GetPage(name: routeCommentPost, page: () => TKDismiss(CommentPostScreen())),
    GetPage(
        name: routeEditArenaPost, page: () => TKDismiss(EditArenaPostScreen())),
    GetPage(
        name: routePublicArticle,
        page: () => TKDismiss(PublishArticleScreen())),

    GetPage(name: routeCreatePoll, page: () => TKDismiss(CreatePollScreen())),
    GetPage(
        name: routePublicArticle,
        page: () => TKDismiss(CreateDocumentPostScreen())),
    //Web Screens
    GetPage(name: routeLoginWeb, page: () => TKDismiss(LoginScreenWeb())),
    GetPage(name: routeDashboardWeb, page: () => DashboardWeb()),
  ];
}

// Tap Keyboard dismiss
class TKDismiss extends StatelessWidget {
  const TKDismiss(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(child: child);
  }
}
