// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:vip_connect/config/routes.dart';
// import 'package:vip_connect/constants.dart';
// import 'package:vip_connect/helper/app_assets.dart';
// import 'package:vip_connect/helper/app_colors.dart';
// import 'package:vip_connect/helper/app_text_styles.dart';
// import 'package:vip_connect/helper/app_texts.dart';
// import 'package:vip_connect/screens/components/spacer.dart';
//
// import '../../components/custom_appbar.dart';
//
// class ChatsScreen extends StatelessWidget {
//   const ChatsScreen({Key? key}) : super(key: key);
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar:
//             customAppBar(title: AppTexts.channelGroups, hideBackButton: true),
//         backgroundColor: AppColors.secondary,
//         body: SingleChildScrollView(
//           padding: EdgeInsets.only(left: 24.w, right: 17.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'dfdad',
//                 style: TextStyle(color: Colors.white),
//               ),
//               VerticalSpacer(height: 26.h),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(routeNewGroup);
//                 },
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 56.h,
//                       height: 56.h,
//                       child: CircleAvatar(
//                         backgroundColor: AppColors.black700,
//                         child: SvgPicture.asset(
//                           AppAssets.plusSvg,
//                           height: 24.h,
//                           width: 24.w,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                     HorizontalSpacer(
//                       width: 17.w,
//                     ),
//                     Text(
//                       AppTexts.createNewChannel,
//                       style: AppTextStyle.rubik12_600
//                           .copyWith(fontSize: kFontSize16),
//                     ),
//                   ],
//                 ),
//               ),
//               VerticalSpacer(height: 13.h),
//               Text(
//                 AppTexts.channels,
//                 style: AppTextStyle.rubik12_600.copyWith(fontSize: kFontSize20),
//               ),
//               VerticalSpacer(height: 11.h),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: 2,
//                 itemBuilder: (context, index) {
//                   return CustomChatListTile(
//                     onTap: () {},
//                   );
//                 },
//               ),
//               VerticalSpacer(height: 8.h),
//               Text(
//                 AppTexts.directMessage,
//                 style: AppTextStyle.rubik12_600.copyWith(fontSize: kFontSize20),
//               ),
//               VerticalSpacer(height: 11.h),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   return CustomChatListTile(
//                     onTap: () {
//                       Get.toNamed(routeMessage);
//                     },
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
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
//                     style: AppTextStyle.bodyRegular.copyWith(
//                         color: AppColors.white500, fontSize: kFontSize14),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 Text(
//                   "2 min ago",
//                   style: AppTextStyle.bodyRegular.copyWith(
//                     color: AppColors.white500,
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
// }
