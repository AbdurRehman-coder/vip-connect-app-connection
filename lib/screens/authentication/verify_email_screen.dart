import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vip_connect/controller/user_profile_controller.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/authentication/login_screen.dart';

import '../../helper/app_colors.dart';
import '../../services/user_profile_firestore.dart';
import '../dashboard/dashboard.dart';

class VerifyEmailScreen extends StatefulWidget {
  VerifyEmailScreen(
      {Key? key,
      this.userEmail,
      this.firstName,
      this.lastName,
      this.jobTitle,
      this.employerName,
      this.cityName,
      this.stateName,
      this.bioText,
      this.industry})
      : super(key: key);

  String? userEmail;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? employerName;
  String? cityName;
  String? stateName;
  String? bioText;
  String? industry;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final profileController = Get.put(UserProfileController());

  String? email = '';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    print('user first name222:: ${profileController.firstName.value}');

    /// User needs to be created first
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!_isEmailVerified) {
      sendVerificationEmail();

      /// timer is used to check every 3 seconds the email verification status
      timer = Timer.periodic(Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    }

    // Obx(
    //     (){
    //
    //       return Container();
    //     }
    //);
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      // utils.showSnackBar();
    }
  }

  Future checkEmailVerified() async {
    // print('user first name:: ${profileController.firstName.value}');
    final currentUser = FirebaseAuth.instance.currentUser;

    /// Get the FCM token for the user
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();

    // print('user fcm token on registration::: ${fcmToken}');

    /// call after email verification
    await FirebaseAuth.instance.currentUser?.reload();
    print('user first name:: ${profileController.firstName.value}');

    setState(() {
      email = currentUser?.email.toString();
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (_isEmailVerified) {
        print('verified user data: ${FirebaseAuth.instance.currentUser}');

        UserModel customUser = UserModel(
          firstName: widget.firstName,
          lastName: widget.lastName,
          fullName: '${widget.firstName} ${widget.lastName}',
          uid: currentUser?.uid,
          fcmToken: fcmToken,
          userEmail: currentUser?.email,
          createdAt: Timestamp.now(),
          isEmailVerified: true,
          jobTitle: widget.jobTitle,
          employerName: widget.employerName,
          cityName: widget.cityName,
          stateName: widget.stateName,
          industry: widget.industry,
          bio: widget.bioText,
        );

        // print('user before creating its document: ${_customUser.firstName}');
        /// passing the user to firestore to create user doc there
        /// this will create user in firestore only if it is verified user
        FirestoreDatabase().createUser(customUser);

        /// cancel the timer if user is verified
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _isEmailVerified
      ? Dashboard()
      : Scaffold(
          backgroundColor: AppColors.secondary,
          appBar: AppBar(
            title: const Text(
              'Verify Email',
              style: TextStyle(color: AppColors.white),
            ),
            centerTitle: true,
            backgroundColor: AppColors.secondary,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Lottie.asset(
                //   // 'https://assets1.lottiefiles.com/packages/lf20_ATMEN2.json',
                //     'assets/animations/email_verification.json',
                //     height: 200.h,
                //
                //     controller: _animationController,
                //     onLoaded: (composition){
                //       _animationController.duration = composition.duration;
                //       _animationController.repeat();
                //     },
                //     repeat: true
                // ),
                Image.asset(
                  'assets/image/email_open.png',
                  height: 150.h,
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Confirm your email address',
                  style: TextStyle(color: AppColors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'We sent a confirmation email to:',
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  email.toString(),
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                ),
                // GetX<UserProfileController>(
                //   builder: (controller) => Text(controller.userEmail.value, style: const TextStyle(color: AppColors.white, fontSize: 16),)),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    'Check your email and click on confirmation link to continue.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: AppColors.primaryLight,
                  ),
                  icon: const Icon(
                    Icons.email_outlined,
                    size: 32,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Resend Link',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                TextButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      timer?.cancel();
                      FirebaseAuth.instance.currentUser?.delete();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()),
                          ModalRoute.withName('/'));
                    })
              ],
            ),
          ),
        );
}
