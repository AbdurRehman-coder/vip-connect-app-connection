import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../services/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: 'Login'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 26.h),
                Image.asset(
                  AppAssets.logoImg,
                  height: 121.h,
                ),
                SizedBox(height: 30.h),
                CustomTextField(
                    controller: _emailController,
                    mainTitle: 'Email Address',
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
                VerticalSpacer(height: 16.h),
                CustomTextField(
                  controller: _passwordController,
                  mainTitle: AppTexts.password,
                  hintText: "Your password",
                  filled: true,
                  obscureText: true,
                  fillColor: AppColors.primary,
                  prefixWidget: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: SvgPicture.asset(
                      AppAssets.lockSvg,
                      height: 24.h,
                      width: 24.h,
                    ),
                  ),
                  onSaved: (String? newValue) {},
                  validator: (password) =>
                      password?.trim() != null && password!.trim().length < 8
                          ? 'Enter a minimum of 8 characters'
                          : null,
                ),
                VerticalSpacer(height: 24.h),
                CommonButton(
                  title: 'Login',
                  iconData: '',
                  isFill: true,
                  isIconVisible: false,
                  onPressed: () {
                    // Get.toNamed(routeDashboard);
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) return;

                    /// if form validated then call the sign in from services
                    AuthServices.signIn(
                        context: context,
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim());

                    /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                    /// next screen
                    FocusScope.of(context).unfocus();
                  },
                  iconColor: AppColors.transparent,
                  buttonShouldDisable: false,
                ),
                VerticalSpacer(height: 24.h),
                TextButton(
                    onPressed: () {
                      Get.toNamed(routeForgetPassword);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: AppTextStyle.bodyMedium,
                    )),
                VerticalSpacer(height: 24.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(routePrivacyPolicy);
                  },
                  child: Text(
                    "By continuing, you agree to the Terms of Services & Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyRegular
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                VerticalSpacer(height: 72.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Account?",
                      style: AppTextStyle.h3.copyWith(
                        fontSize: kFontSize14,
                        color: AppColors.primary,
                      ),
                    ),
                    HorizontalSpacer(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(routeSignUp);
                      },
                      child: Text(
                        "Sign Up Here!",
                        style: AppTextStyle.h3.copyWith(
                          fontSize: kFontSize14,
                          color: AppColors.blackHalfText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
