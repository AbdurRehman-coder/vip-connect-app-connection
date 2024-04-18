import 'package:flutter/material.dart';
import 'package:vip_connect/helper/app_colors.dart';

const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;
const int customScreenSize = 1100;

class Responsiveness extends StatelessWidget {
  const Responsiveness({Key? key, required this.largeScreen, required this.mediumScreen, required this.smallScreen,}) : super(key: key);
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      color: AppColors.red,
    );
  }
}
