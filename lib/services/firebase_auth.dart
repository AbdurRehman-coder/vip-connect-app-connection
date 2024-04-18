import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/controller/sign_up_user_info_controller.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/screens/dashboard/dashboard.dart';

import '../main.dart';
import '../screens/authentication/verify_email_screen.dart';
import '../utils/show_snackbar.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  /// SIGN UP METHOD
  static Future signUp(
      {BuildContext? context,
      String? email,
      String? password,
      String? firstN,
      String? lastN,
      String? jobT,
      String? employerN,
      String? cityN,
      String? stateN,
      String? bioTxt,
      String? industryName}) async {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // Future.delayed(Duration(seconds: 3));
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((value) {});
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
      ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
          Utils.showSnackBar('User Registered successfully', Colors.black54));
      // Get.offAllNamed(routeVerifyEmail,);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyEmailScreen(
                    userEmail: email,
                    firstName: firstN,
                    lastName: lastN,
                    employerName: employerN,
                    cityName: cityN,
                    stateName: stateN,
                    bioText: bioTxt,
                    industry: industryName,
                    jobTitle: jobT,
                  )),
          ModalRoute.withName('/'));

      /// clear all signup text controllers, after successfully signup
      Provider.of<SignUpUserInfoController>(context, listen: false)
          .clearAllSignUpTextFieldControllers();
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Utils.showSnackBar(e.message.toString(), Colors.redAccent));
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    }

    /// Navigator(context) not working
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  /// SIGN IN METHOD
  static Future signIn(
      {BuildContext? context, String? email, String? password}) async {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // Future.delayed(Duration(seconds: 3));
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              ModalRoute.withName('/')));
      ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
          Utils.showSnackBar('Sign in successfully', Colors.black54));

      // Get.offAllNamed(routeDashboard);

      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Utils.showSnackBar(e.message.toString(), Colors.redAccent));
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    }

    /// Navigator(context) not working
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  /// Reset Password
  Future resetPassword({
    BuildContext? context,
    String? email,
  }) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email!)
          .then((value) {
        print('forget password value: ');
        if (FirebaseAuth.instance.currentUser != null) {
          print('sign out callled');
          Future.delayed(Duration(seconds: 2), () {
            Get.offAllNamed(routeLogin);
            FirebaseAuth.instance.signOut();
          });
        } else {
          Future.delayed(Duration(seconds: 2), () {
            print('simple callled');
            Get.offAllNamed(routeLogin);
          });
        }

        Get.snackbar(
          '',
          '',
          colorText: Colors.black,
          backgroundColor: Colors.white,
          titleText: const Text(
            'reset link send successfully to the email',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          snackPosition: SnackPosition.BOTTOM,
        );
        // Future.delayed(Duration(seconds: 2));
        // ScaffoldMessenger.of(context!).showSnackBar(Utils.showSnackBar(
        //     'reset link send successfully to the email', Colors.black54));

        // Utils.showSnackBar('Password reset email sent');
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
          Utils.showSnackBar(e.message.toString(), Colors.redAccent));
      // Utils.showSnackBar(e.message.toString());
    }
  }

  // create user obj based on firebase user
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  //Required stream
  Stream<UserModel?> get userState {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  /// get user profile stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> get getUserProfileStream {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(user?.uid)
        .snapshots();
  }

  /// SIGN OUT METHOD
  static Future signOut() async {
    await FirebaseAuth.instance.signOut();
    print('signout');
  }

  Future deleteUserAccount(
      {BuildContext? context, String? email, String? password}) async {
    User? user = _auth.currentUser;
    AuthCredential authCredential =
        EmailAuthProvider.credential(email: email!, password: password!);
    await user?.reauthenticateWithCredential(authCredential).then((userValue) {
      /// Delete Likes and Dislikes from posts where current user likes and dislikes
      deleteUserLikesDislikes();

      /// delete all user comments from different posts
      deleteAllUserComments();

      /// call this method to delete all users data from firestore
      deleteUserPosts();

      Future.delayed(Duration(seconds: 2), () {
        userValue.user?.delete().then((deleteValue) {
          ScaffoldMessenger.of(context!).showSnackBar(Utils.showSnackBar(
              'User account deleted successfully', Colors.redAccent));
          // Get.snackbar('User account deleted', 'Success');
          /// Delete Likes and Dislikes from posts where current user likes and dislikes
          deleteUserLikesDislikes();

          /// delete all user comments from different posts
          deleteAllUserComments();

          /// call this method to delete all users data from firestore
          deleteUserPosts();

          /// When delete the user account from firebase Auth, then also
          /// delete its document object from Firestore.
          FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .delete()
              .then((value) {
            print('user document deleted');
          });

          /// route to Login

          print('posts deleted successfully...');
          Get.offAllNamed(routeLogin);
        });
      });
    }).catchError((onError) {
      print('on user account delete error: $onError');

      ScaffoldMessenger.of(context!).showSnackBar(
          Utils.showSnackBar(onError.message.toString(), Colors.redAccent));
    });
  }

  /// Delete all users data when user click on delete button

  Future<void> deleteUserPosts() async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    final batch = FirebaseFirestore.instance.batch();

    /// Delete user document from users collection
    // await FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(currentUser)
    //     .delete();

    /// Delete user's own posts
    final posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: currentUser.toString())
        .get();
    for (final post in posts.docs) {
      post.reference.delete();
      // batch.delete(post.reference);
    }
  }

  deleteUserLikesDislikes() async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    // likes
    final QuerySnapshot likesSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('likes', arrayContains: currentUser)
        .get();
    for (final doc in likesSnapshot.docs) {
      final likes = List<String>.from(doc.get('likes'));
      likes.remove(currentUser);
      await doc.reference.update({'likes': likes});
    }
    // dislikes
    final QuerySnapshot dislikeSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('dislikes', arrayContains: currentUser)
        .get();
    for (final doc in dislikeSnapshot.docs) {
      final disLikes = List<String>.from(doc.get('dislikes'));
      disLikes.remove(currentUser);
      await doc.reference.update({'dislikes': disLikes});
    }
  }

  deleteAllUserComments() async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;

    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    QuerySnapshot postsSnapshot = await postsRef.get();

    for (DocumentSnapshot postDoc in postsSnapshot.docs) {
      Map<String, dynamic> commentData = postDoc.data() as Map<String, dynamic>;
      List<dynamic> comments = commentData['comments'];

      if (comments != null && comments.isNotEmpty) {
        List<Map<String, dynamic>> updatedComments = [];

        for (Map<String, dynamic> comment in comments) {
          if (comment['uid'] != currentUser) {
            updatedComments.add(comment);
          } else {
            // print('yes user uid in comments');
          }
        }

        if (updatedComments.length < comments.length) {
          /// Update comments array in Firestore
          await postDoc.reference.update({'comments': updatedComments});
        }
      }
    }
  }
}
