// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:vip_connect/config/routes.dart';
// import 'package:vip_connect/helper/app_assets.dart';
// import 'package:vip_connect/helper/app_colors.dart';
// import 'package:vip_connect/helper/app_text_styles.dart';
// import 'package:vip_connect/helper/app_texts.dart';
// import 'package:vip_connect/screens/components/common_button.dart';
// import 'package:vip_connect/screens/components/custom_appbar.dart';
// import 'package:vip_connect/screens/components/custom_textfield.dart';
// import 'package:vip_connect/screens/components/spacer.dart';
//
// class NewPasswordScreen extends StatelessWidget {
//   const NewPasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       appBar: customAppBar(title: AppTexts.newPassword),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Column(
//           children: [
//             VerticalSpacer(height: 24.h),
//             Text(
//               "Enter your New Password.",
//               style: AppTextStyle.bodyRegular
//                   .copyWith(color: AppColors.disableText),
//             ),
//             VerticalSpacer(height: 24.h),
//             CustomTextField(
//               mainTitle: AppTexts.password,
//               hintText: AppTexts.password,
//               obscureText: true,
//               filled: true,
//               fillColor: AppColors.primary,
//               prefixWidget: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                 child: SvgPicture.asset(
//                   AppAssets.lockSvg,
//                   height: 24.h,
//                   width: 24.h,
//                 ),
//               ),
//               onSaved: (String? newValue) {},
//               validator: (String? value) {},
//             ),
//             VerticalSpacer(height: 8.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Must be at least 8 characters.",
//                   style: AppTextStyle.bodyRegular,
//                 ),
//                 const Icon(
//                   Icons.check,
//                   color: AppColors.primary,
//                 ),
//               ],
//             ),
//             VerticalSpacer(height: 16.h),
//             CustomTextField(
//               mainTitle: AppTexts.confirmPassword,
//               hintText: AppTexts.confirmPassword,
//               obscureText: true,
//               filled: true,
//               fillColor: AppColors.primary,
//               prefixWidget: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                 child: SvgPicture.asset(
//                   AppAssets.lockSvg,
//                   height: 24.h,
//                   width: 24.h,
//                 ),
//               ),
//               onSaved: (String? newValue) {},
//               validator: (String? value) {},
//             ),
//             VerticalSpacer(height: 33.h),
//             CommonButton(
//               title: AppTexts.resetPassword,
//               iconData: '',
//               isFill: true,
//               isIconVisible: false,
//               onPressed: () {
//                 Get.offAllNamed(routeOnBoarding);
//               },
//               iconColor: AppColors.transparent,
//               buttonShouldDisable: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
