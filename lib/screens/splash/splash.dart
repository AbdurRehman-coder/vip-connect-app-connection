
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/screens/authentication/login_screen.dart';
import '../../config/routes.dart';
import '../../helper/app_assets.dart';
import '../../helper/app_colors.dart';
import '../../model/user_model.dart';
import '../../services/firebase_auth.dart';
import '../authentication/verify_email_screen.dart';
import '../components/background_design.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      final user = Provider.of<UserModel?>(context, listen: false);
      if(user?.uid == null){
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) =>  LoginScreen()));
        Get.offAndToNamed(routeLogin);

      } else{
        Get.offAndToNamed(routeVerifyEmail);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final user = Provider.of<UserModel?>(context);

    // if (user?.uid == null) {
    //   return LoginScreen();
    // }
    // return VerifyEmailScreen();


        return Scaffold(
      backgroundColor: AppColors.secondary,
      body: BackgroundDesign(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Image.asset(
              AppAssets.logoImg,
              height: 192.h,
              width: 340.w,
            ),
          ],
        ),
      ),
    );
  }
}
