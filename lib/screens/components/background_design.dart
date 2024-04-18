import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/helper/app_assets.dart';

class BackgroundDesign extends StatelessWidget {
  const BackgroundDesign({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 60.h,
                right: 0,
                child: SvgPicture.asset(
                  AppAssets.shape1Svg,
                  height: 242.h,
                ),
              ),
              Positioned(
                top: 0.h,
                right: 0,
                child: SvgPicture.asset(
                  AppAssets.shape2Svg,
                  height: 396.h,
                ),
              ),
              Positioned(
                top: 260.h,
                left: 54.w,
                child: SvgPicture.asset(
                  AppAssets.shape3Svg,
                  height: 48.h,
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 0,
                child: SvgPicture.asset(
                  AppAssets.shape4Svg,
                  height: 280.h,
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 0,
                child: SvgPicture.asset(
                  AppAssets.shape5Svg,
                  height: 196.h,
                ),
              ),
              Positioned(
                bottom: 156.h,
                right: 80.w,
                child: SvgPicture.asset(
                  AppAssets.shape6Svg,
                  height: 20.h,
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
