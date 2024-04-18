import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../services/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: AppTexts.resetPassword),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpacer(height: 24.h),
              Text(
                'Please enter your email address. We will send you a link',
                style: AppTextStyle.bodyRegular
                    .copyWith(color: AppColors.disableText),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                  controller: _emailController,
                  mainTitle: AppTexts.emailAddress,
                  hintText: "Your email address",
                  filled: true,
                  fillColor: AppColors.primary,
                  prefixWidget: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: SvgPicture.asset(
                      AppAssets.emailFillSvg,
                      height: 24.h,
                      width: 24.h,
                    ),
                  ),
                  onSaved: (String? newValue) {},
                  validator: (email) => email?.trim() != null &&
                          !EmailValidator.validate(email!.trim())
                      ? 'Enter a valid email'
                      : null),
              SizedBox(height: 165.h),
              CommonButton(
                title: AppTexts.resetPassword,
                iconData: '',
                isFill: true,
                isIconVisible: false,
                onPressed: () {
                  // Get.toNamed(routeOtp);

                  // Navigator.popAndPushNamed(context, routeLogin);
                  AuthServices().resetPassword(
                      context: context, email: _emailController.text.trim());
                  // AuthServices.signOut();
                },
                iconColor: AppColors.transparent,
                buttonShouldDisable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
