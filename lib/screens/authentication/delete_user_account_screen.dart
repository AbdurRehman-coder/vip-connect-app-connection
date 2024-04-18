import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../services/firebase_auth.dart';

class DeleteUserAccountScreen extends StatefulWidget {
  DeleteUserAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteUserAccountScreen> createState() =>
      _DeleteUserAccountScreenState();
}

class _DeleteUserAccountScreenState extends State<DeleteUserAccountScreen> {
  late final TextEditingController _emailController;

  final TextEditingController _passwordController = TextEditingController();

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? email = FirebaseAuth.instance.currentUser?.email;

    _emailController = TextEditingController(text: email);
  }

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
      appBar: customAppBar(title: 'Delete User'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 26.h),
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
                          ? 'Enter min. 8 character'
                          : null,
                ),
                SizedBox(height: 24.h),
                _isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                        ),
                      )
                    : CommonButton(
                        title: 'Delete Account',
                        textColor: AppColors.red,
                        borderColor: AppColors.red,
                        iconData: '',
                        isFill: false,
                        isIconVisible: false,
                        onPressed: () {
                          // deleteUserLikesDislikes();
                          // Get.toNamed(routeDashboard);
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) return;

                          setState(() {
                            _isLoading = true;
                          });

                          /// if form validated then call the sign in from services
                          AuthServices().deleteUserAccount(
                              context: context,
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());

                          /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                          /// next screen
                          FocusScope.of(context).unfocus();
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        iconColor: AppColors.transparent,
                        buttonShouldDisable: false,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
