import 'package:flutter/material.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class WebAllUsers extends StatelessWidget {
  const WebAllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black800,
      width: double.infinity,
      child: Column(
        children: [
          const VerticalSpacer(height: 20),
          Row(
            children: [
              const HorizontalSpacer(width: 30),
              Text(
                AppTexts.allUsers,
                style: AppTextStyle.web4,
              ),
              const Spacer(),
              Container(
                height: 45,
                width: 260,
                color: AppColors.randomColor1,
              ),
              const HorizontalSpacer(width: 30),
            ],
          ),
          const VerticalSpacer(height: 30),
        ],
      ),
    );
  }
}
