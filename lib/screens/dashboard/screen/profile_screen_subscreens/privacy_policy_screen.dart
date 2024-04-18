import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: 'Privacy policy'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading1,
              sentence: AppTexts.privacySentence1,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading2,
              sentence: AppTexts.privacySentence2,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading3,
              sentence: AppTexts.privacySentence3,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading4,
              sentence: AppTexts.privacySentence4,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading5,
              sentence: AppTexts.privacySentence5,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading6,
              sentence: AppTexts.privacySentence6,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading7,
              sentence: AppTexts.privacySentence7,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading8,
              sentence: AppTexts.privacySentence8,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading9,
              sentence: AppTexts.privacySentence9,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading10,
              sentence: AppTexts.privacySentence10,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading11,
              sentence: AppTexts.privacySentence11,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading12,
              sentence: AppTexts.privacySentence12,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading13,
              sentence: AppTexts.privacySentence13,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading14,
              sentence: AppTexts.privacySentence14,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading15,
              sentence: AppTexts.privacySentence15,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading16,
              sentence: AppTexts.privacySentence16,
            ),
            CustomPrivacyPolicyTexts(
              heading: AppTexts.privacyHeading17,
              sentence: AppTexts.privacySentence17,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPrivacyPolicyTexts extends StatelessWidget {
  CustomPrivacyPolicyTexts(
      {Key? key, required this.heading, required this.sentence})
      : super(key: key);
  String heading, sentence;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpacer(height: 16.h),
        Text(
          heading,
          style: AppTextStyle.bodyRegular.copyWith(
            fontSize: kFontSize14,
            fontWeight: FontWeight.w700,
            color: AppColors.white300,
          ),
        ),
        VerticalSpacer(height: 20.h),
        Text(
          sentence,
          style: AppTextStyle.bodyRegular.copyWith(
            fontSize: kFontSize14,
            fontWeight: FontWeight.w400,
            color: AppColors.white300,
          ),
        ),
      ],
    );
  }
}
