import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../services/firebase_auth.dart';

class LoginScreenWeb extends GetResponsiveView {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Row(
          children: [
            HorizontalSpacer(width: 99.w),
            Image.asset(
              AppAssets.logoImg,
              height: 295.h,
              width: 526.w,
            ),
            HorizontalSpacer(width: 105.w),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.signIn,
                      style: AppTextStyle.web1,
                    ),
                    VerticalSpacer(height: 18.h),
                    Text(
                      "Hello James welcome back to your dashboard.",
                      style: AppTextStyle.web2,
                    ),
                    VerticalSpacer(height: 31.h),
                    CustomTextField(
                      controller: _emailController,
                      mainTitle: AppTexts.emailAddress,
                      hintText: "Your email address",
                      filled: true,
                      fillColor: AppColors.primary,
                      prefixWidget: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.w),
                        child: SvgPicture.asset(
                          AppAssets.emailFillSvg,
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    VerticalSpacer(height: 20.h),
                    CustomTextField(
                      controller: _passwordController,
                      isWeb: true,
                      mainTitle: AppTexts.password,
                      hintText: "Your password",
                      filled: true,
                      obscureText: true,
                      fillColor: AppColors.primary,
                      prefixWidget: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.w),
                        child: SvgPicture.asset(
                          AppAssets.lockSvg,
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                      onSaved: (String? newValue) {},
                      validator: (String? value) {},
                    ),
                    VerticalSpacer(height: 90.h),
                    CommonButton(
                      isWeb: true,
                      title: 'Login',
                      iconData: '',
                      isFill: true,
                      isIconVisible: false,
                      onPressed: () {
                        // final isValid = _formKey.currentState!.validate();
                        // if(!isValid) return;
                        // /// if form validated then call the sign in from services
                        // AuthServices.signIn(context: context, email: _emailController.text.trim(), password: _passwordController.text.trim());
                        // /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                        // /// next screen
                        // FocusScope.of(context).unfocus();
                        Get.toNamed(routeDashboardWeb);
                      },
                      iconColor: AppColors.transparent,
                      buttonShouldDisable: false,
                    ),
                  ],
                ),
              ),
            ),
            HorizontalSpacer(width: 130.w),
          ],
        ),
      ),
    );
  }
}
