import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/controller/user_profile_controller.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../services/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? dropdownValue;
  bool addIndustryField = false;
  bool selectIndustry = false;

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _jobTitleController;
  TextEditingController? _employerController;
  TextEditingController? _cityController;
  TextEditingController? _stateController;
  TextEditingController? _bioController;
  TextEditingController? _industryController;
  TextEditingController? _emailController;
  TextEditingController? _passController;
  TextEditingController? _confirmPassController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfoController =
        Provider.of<SignUpUserInfoController>(context, listen: false);

    /// passing initial value to the controller
    _firstNameController = TextEditingController(
        text: userInfoController.firstNameController.text);
    _lastNameController =
        TextEditingController(text: userInfoController.lastNameController.text);
    _jobTitleController =
        TextEditingController(text: userInfoController.jobTitleController.text);
    _employerController =
        TextEditingController(text: userInfoController.employerController.text);
    _cityController =
        TextEditingController(text: userInfoController.cityController.text);
    _stateController =
        TextEditingController(text: userInfoController.stateController.text);
    _bioController =
        TextEditingController(text: userInfoController.bioController.text);
    _industryController =
        TextEditingController(text: userInfoController.industryController.text);
    _emailController =
        TextEditingController(text: userInfoController.emailController.text);
    _passController =
        TextEditingController(text: userInfoController.passController.text);
    _confirmPassController = TextEditingController(
        text: userInfoController.confirmPassController.text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _jobTitleController?.dispose();
    _employerController?.dispose();
    _bioController?.dispose();
    _industryController?.dispose();
    _passController?.dispose();
    _confirmPassController?.dispose();
    _emailController?.dispose();
  }

  /// create UserGetController instance
  UserProfileController userProfileController =
      Get.put(UserProfileController());

  ///This key will be used to identify the state of the form.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userInfoController = Provider.of<SignUpUserInfoController>(context);
    return Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: customAppBar(title: 'Sign Up'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Text(
                  "Create Account",
                  style: AppTextStyle.bodyRegular.copyWith(
                    color: AppColors.disableText,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                    controller: _firstNameController,
                    mainTitle: AppTexts.firstName,
                    hintText: AppTexts.enterYour + AppTexts.firstName,
                    filled: true,
                    fillColor: AppColors.primary,
                    onChanged: (value) {
                      userInfoController.setFirstName(value!);
                    },
                    onSaved: (String? newValue) {},
                    validator: (value) => value != null && value.length < 2
                        ? 'Enter first name'
                        : null),
                SizedBox(height: 10.h),
                CustomTextField(
                    controller: _lastNameController,
                    mainTitle: AppTexts.lastName,
                    hintText: AppTexts.enterYour + AppTexts.lastName,
                    filled: true,
                    fillColor: AppColors.primary,
                    onSaved: (String? newValue) {},
                    onChanged: (value) {
                      userInfoController.setLastName(value!);
                    },
                    validator: (value) => value != null && value.length < 2
                        ? 'Enter last name'
                        : null),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _jobTitleController,
                  mainTitle: AppTexts.jobTitle,
                  hintText: AppTexts.enterYour + AppTexts.jobTitle,
                  filled: true,
                  fillColor: AppColors.primary,
                  onSaved: (String? newValue) {},
                  onChanged: (value) {
                    userInfoController.setJobTitle(value!);
                  },
                  validator: (value) => value != null && value.length < 2
                      ? 'Enter a job title'
                      : null,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _employerController,
                  mainTitle: AppTexts.employer,
                  hintText: "${AppTexts.enterYour}${AppTexts.employer} Name",
                  filled: true,
                  fillColor: AppColors.primary,
                  onSaved: (String? newValue) {},
                  onChanged: (value) {
                    userInfoController.setEmployerController(value!);
                  },
                  validator: (value) {},
                ),
                SizedBox(height: 10.h),

                /// city field
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _cityController,
                  mainTitle: 'City',
                  hintText: 'Enter your City',
                  filled: true,
                  fillColor: AppColors.primary,
                  onSaved: (String? newValue) {},
                  onChanged: (value) {
                    userInfoController.setCityController(value!);
                  },
                  validator: (value) => value != null && value.length < 2
                      ? 'Enter your city'
                      : null,
                ),

                /// state field
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _stateController,
                  mainTitle: 'State',
                  hintText: 'Enter your State',
                  filled: true,
                  fillColor: AppColors.primary,
                  onSaved: (String? newValue) {},
                  onChanged: (value) {
                    userInfoController.setStateController(value!);
                  },
                  validator: (value) => value != null && value.length < 2
                      ? 'Enter your state'
                      : null,
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextField(
                    controller: _bioController,
                    mainTitle: AppTexts.bio,
                    hintText: AppTexts.addExperience,
                    maxLines: 4,
                    filled: true,
                    fillColor: AppColors.primary,
                    onSaved: (String? newValue) {},
                    onChanged: (value) {
                      userInfoController.setBioController(value!);
                    },
                    validator: (value) => value != null && value.length < 2
                        ? 'Bio must not be empty'
                        : null),
                SizedBox(height: 10.h),
                Text(
                  'Add Industry',
                  style: AppTextStyle.bodyRegular
                      .copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField(
                  menuMaxHeight: 300.h,
                  alignment: AlignmentDirectional.topStart,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    filled: true,
                    fillColor: AppColors.primary,
                  ),
                  borderRadius: BorderRadius.circular(kBorderRadius20),
                  dropdownColor: AppColors.primary,
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      selectIndustry = true;
                    });
                  },
                  validator: (value) =>
                      value == null && addIndustryField == false
                          ? 'Industry name is required'
                          : null,
                  isExpanded: true,
                  items: <String>[
                    "3PL",
                    "Aviation",
                    "Automotive",
                    "Construction",
                    "Cannabis",
                    "Critical Infrastructure",
                    "Entertainment/Amusement Parks",
                    "Government",
                    "Gaming",
                    "Retail",
                    "Education",
                    "Healthcare",
                    "Hospitality",
                    "IT",
                    "Marketing",
                    "Security/Surveillance",
                    "Technology",
                    "Transportation",
                    "Telecommunication",
                    "Oil & Gas",
                    "Professional Sports",
                    "Public Safety",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyRegular,
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 10.h),
                // addIndustryField == false && selectIndustry == true
                _industryController?.text == null && addIndustryField == true
                    ? const Text(
                        'Select an industry',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : Container(),
                SizedBox(height: 16.h),
                if (addIndustryField == false)
                  InkWell(
                    onTap: () {
                      setState(() {
                        addIndustryField = true;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 24.r,
                          color: AppColors.primary,
                        ),
                        HorizontalSpacer(width: 5.w),
                        Text(
                          AppTexts.addIndustry,
                          style: AppTextStyle.bodyRegular.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: kFontSize14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (addIndustryField)
                  CustomTextField(
                    controller: _industryController,
                    mainTitle: AppTexts.addIndustryName,
                    hintText: AppTexts.industryName,
                    filled: true,
                    fillColor: AppColors.primary,
                    onSaved: (String? newValue) {},
                    onChanged: (value) {
                      userInfoController.setIndustryController(value!);
                    },
                    validator: selectIndustry == false
                        ? (value) => value != null && value.length < 2
                            ? 'Enter your industry name'
                            : null
                        : (value) {},
                  ),
                SizedBox(height: 10.h),

                /// Email
                CustomTextField(
                    controller: _emailController,
                    mainTitle: 'Email Address',
                    hintText: 'Enter Email',
                    filled: true,
                    fillColor: AppColors.primary,
                    onSaved: (String? newValue) {},
                    onChanged: (value) {
                      userInfoController.setEmailController(value!);
                    },
                    validator: (email) => email?.trim() != null &&
                            !EmailValidator.validate(email!.trim())
                        ? 'Enter a valid email'
                        : null),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _passController,
                  mainTitle: AppTexts.password,
                  hintText: "Enter ${AppTexts.password}",
                  obscureText: true,
                  filled: true,
                  fillColor: AppColors.primary,
                  onSaved: (String? newValue) {},
                  onChanged: (value) {
                    userInfoController.setPasswordController(value!);
                  },
                  validator: (password) =>
                      password?.trim() != null && password!.trim().length < 8
                          ? 'Enter a minimum of 8 characters'
                          : null,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _confirmPassController,
                  mainTitle: AppTexts.confirmPassword,
                  hintText: AppTexts.enter + AppTexts.confirmPassword,
                  obscureText: true,
                  filled: true,
                  fillColor: AppColors.primary,
                  onSaved: (String? newValue) {},
                  onChanged: (value) {
                    userInfoController.setConfirmPasswordController(value!);
                  },
                  validator: (password) =>
                      password?.trim() != null && password!.trim().length < 8
                          ? 'Enter a minimum of 8 characters'
                          : password!.trim() != _passController?.text
                              ? 'Password not matched'
                              : null,
                ),
                SizedBox(height: 24.h),
                CommonButton(
                  title: 'Sign Up',
                  iconData: '',
                  isFill: true,
                  isIconVisible: false,
                  onPressed: () {
                    // print('industrial ontap: ${_industryController?.text}');
                    // print('dropdown value ontap: ${dropdownValue}');

                    if (dropdownValue == null &&
                        _industryController?.text == null) {
                      selectIndustry = true;
                      // setState(() {});
                    }
                    bool isValid = _formKey.currentState!.validate() &&
                        _industryController?.text != null;
                    bool isIndustrySelected =
                        dropdownValue != null ? true : false;
                    // print('dropdownvalue condition: ${selectIndustry}');

                    if (!isValid) return;

                    userProfileController.setUserInformation(
                      firstN: _firstNameController?.text,
                      lastN: _lastNameController?.text,
                      jobT: _jobTitleController?.text,
                      employerN: _employerController?.text,
                      city: _cityController?.text,
                      bioT: _bioController?.text,
                      state: _stateController?.text,
                      industryN: dropdownValue,
                      email: _emailController?.text,
                    );
                    AuthServices.signUp(
                      context: context,
                      email: _emailController?.text.trim(),
                      password: _passController?.text.trim(),
                      firstN: _firstNameController?.text,
                      lastN: _lastNameController?.text,
                      employerN: _employerController?.text,
                      cityN: _cityController?.text,
                      stateN: _stateController?.text,
                      industryName: dropdownValue,
                      jobT: _jobTitleController?.text,
                      bioTxt: _bioController?.text,
                    );

                    /// Unfocuse the textfield will close all the open keyboards so it will avoid the overflow issues on
                    /// next screen
                    FocusScope.of(context).unfocus();
                  },
                  iconColor: AppColors.transparent,
                  buttonShouldDisable: false,
                ),
                VerticalSpacer(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTexts.alreadyHaveAccount,
                      style: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.disableText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(routeLogin);
                      },
                      child: Text(
                        "  Login",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalSpacer(height: 24.h),
              ],
            ),
          ),
        ));
  }
}
