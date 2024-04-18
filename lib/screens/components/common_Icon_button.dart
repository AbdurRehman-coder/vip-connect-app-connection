import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/helper/app_colors.dart';

class CommonIconButton extends StatelessWidget {
  final String svgData;
  final bool isFill;
  final Color iconColor;
  final double? height, width;
  final void Function() onPressed;

  CommonIconButton({
    Key? key,
    required this.svgData,
    required this.isFill,
    required this.iconColor,
    this.height,
    this.width,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.button),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 30,
          width: 30,
          // color: Colors.amber,
          child: SvgPicture.asset(
            svgData,
          ),
        ),
      ),

      // child: ElevatedButton(
      //   style: ButtonStyle(
      //     // minimumSize: MaterialStateProperty.all(
      //     //     Size(width ?? double.infinity, height ?? 20.h)),
      //     // elevation: MaterialStateProperty.all(0),
      //     // padding: MaterialStateProperty.all(
      //     //   EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
      //     // ),
      //     //Fixed Size set
      //     // fixedSize: MaterialStateProperty.all( Size(double.infinity,48)),
      //     backgroundColor: isFill
      //         ? MaterialStateProperty.all(AppColors.button)
      //         : MaterialStateProperty.all(AppColors.secondary),
      //     splashFactory: NoSplash.splashFactory,
      //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //       RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(kBorderRadius20),
      //         side: BorderSide(
      //           color: isFill ? AppColors.button : AppColors.primary,
      //         ),
      //       ),
      //     ),
      //     //minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.h)),
      //   ),
      //   onPressed: onPressed,
      //   child: Container(
      //     color: Colors.amber,
      //     child: SvgPicture.asset(
      //       svgData,
      //       height: height,
      //       width: width,
      //     ),
      //   ),
      // ),
    );
  }
}
