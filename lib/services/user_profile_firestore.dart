

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vip_connect/controller/post_controller.dart';

import '../model/user_model.dart';


class FirestoreDatabase{

  final FirebaseFirestore _firstore = FirebaseFirestore.instance;

  Future createUser(UserModel user) async{
    try{
      await _firstore.collection('user').doc(user.uid).set(user.toJson()).then((value){
        print('user added successfully');
      });
    }catch (e) {
      print('error occured will adding new user to firstore: $e');
    }
  }

  Future<UserModel> getCurrentUser(String uid) async{
    try{
      DocumentSnapshot _docSnapshot = await _firstore.collection('user').doc(uid).get();
      UserModel customUser = UserModel.fromJson(_docSnapshot.data() as Map<String, dynamic>);
      return customUser;
    }catch(e){
      print('get user error: $e');
      return UserModel();
    }
  }


  // final postController = Get.put(PostController());




}