import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/controller/create_post_controller.dart';
import 'package:vip_connect/controller/post_controller.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/model/post_model.dart';
import 'package:vip_connect/model/user_model.dart';

class PostsFirestoreDatebase {
  final FirebaseFirestore _firstore = FirebaseFirestore.instance;

  /// Get all posts from firstore
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('posts');

  // final DashboardController dashboardController =
  //     Get.put(DashboardController());
  // final createPostController = Get.put(CreatePostController());

  /// Create Post
  Future createPost(PostModel postModel) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await _firstore
          .collection('posts')
          .doc()
          .set(postModel.toJson())
          .then((value) {
        PostController().updateIsLoading(false);
        Get.offAndToNamed(routeDashboard);
      });
    } catch (e) {
      print('error occured will adding new post to firstore: $e');
    }
  }

  /// Create Polls
  Future createPoll(PostModel postModel) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await _firstore
          .collection('posts')
          .doc()
          .set(postModel.toJson())
          .then((value) {
        PostController().updateIsLoading(false);
        Get.offAndToNamed(routeDashboard);
      });
    } catch (e) {
      print('error occured will adding new post to firstore: $e');
    }
  }

  /// vote on Poll
  Future voteOnPoll({int? postId, List<PollOptions>? options}) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      /// Create a reference to the cities collection
      CollectionReference postRef = _firstore.collection("posts");

      /// Create a query against the collection.
      QuerySnapshot query = await postRef.where("id", isEqualTo: postId).get();
      query.docs.forEach((QueryDocumentSnapshot documentSnapshot) async {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(documentSnapshot.id)
            .update({
          'options': options?.map((e) => e.toJson()).toList(),
        }).then((value) {
          print('voted on poll');
          // Get.snackbar(
          //   ' successfully',
          //   '',
          //   colorText: Colors.white,
          //   backgroundColor: AppColors.disableText,
          //   snackPosition: SnackPosition.BOTTOM,
          //   // icon: const Icon(Icons.add_alert),
          // );
        }).onError((error, stackTrace) {
          print('error while voting $error');
          // Utils.showSnackBar("User not updated", Colors.black);
        });
      });
    } catch (e) {
      print('error occured will adding new post to firstore: $e');
    }
  }

  /// update voters list on Poll
  Future updateVotersField(int id, PollsList pollsList) async {
    /// Create a reference to the cities collection
    CollectionReference postRef = _firstore.collection("posts");

    /// Create a query against the collection.
    QuerySnapshot query = await postRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      postRef.doc(documentSnapshot.id).get().then((docSnap) {
        /// Updating the pollList inside poll document
        _collectionRef.doc(documentSnapshot.id).update({
          'pollsList': FieldValue.arrayUnion([pollsList.toJson()]),
        }).then((value) {
          print('polls List updated Successfully');
        }).onError((error, stackTrace) {
          print('error while change in poll list:: $error}');
        });
      });
    });
  }

  Future<dynamic> getAllPostsData() async {
    try {
      /// Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      /// Get data from docs and convert map to List
      final allPostsData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allPostsData;
    } catch (e) {}
  }

  /// Get sing user for posts
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('user');

  Future<dynamic> getSingleUserData(String uid) async {
    try {
      /// Get docs from collection reference
      DocumentSnapshot? docSnapshot = await _userCollectionRef.doc(uid).get();
      UserModel userr =
          UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

      CreatePostController().setUserModel(userr);

      return docSnapshot.data();
    } catch (e) {
      print('error while get user document for post: ${e}');
    }
  }

  /// LIKES FUNCTION
  Future updateLikesField(int id, String uid) async {
    /// Create a reference to the cities collection
    CollectionReference postRef = _firstore.collection("posts");

    /// Create a query against the collection.
    QuerySnapshot query = await postRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      postRef.doc(documentSnapshot.id).get().then((docSnap) {
        if (docSnap['likes'].contains(uid)) {
          print('likes remove from list');
          FirebaseFirestore.instance
              .collection('posts')
              .doc(documentSnapshot.id)
              .update({
            'likes': FieldValue.arrayRemove([uid]),
          }).then((value) {
            print('likes removed successfully');
          }).onError((error, stackTrace) {
            // Utils.showSnackBar("User not updated", Colors.black);
          });
        } else {
          print('likes add to list');
          FirebaseFirestore.instance
              .collection('posts')
              .doc(documentSnapshot.id)
              .update({
            'likes': FieldValue.arrayUnion([uid]),
          }).then((value) {
            print('likes added successfully');
          }).onError((error, stackTrace) {
            // Utils.showSnackBar("User not updated", Colors.black);
          });
        }
        if (docSnap['dislikes'].contains(uid)) {
          print('removed uid from dislikes list when hit like');
          FirebaseFirestore.instance
              .collection('posts')
              .doc(documentSnapshot.id)
              .update({
                "dislikes": FieldValue.arrayRemove([uid])
              })
              .then((value) {})
              .onError((error, stackTrace) {
                // Utils.showSnackBar("User not updated", Colors.black);
              });
        }
      });
    });
  }

  /// DISLIKES FUNCTION
  Future updateDislikeField(int id, String uid) async {
    /// Create a reference to the cities collection
    CollectionReference postRef = _firstore.collection("posts");

    /// Create a query against the collection.
    QuerySnapshot query = await postRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      postRef.doc(documentSnapshot.id).get().then((docSnap) {
        if (docSnap['dislikes'].contains(uid)) {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(documentSnapshot.id)
              .update({
                'dislikes': FieldValue.arrayRemove([uid]),
              })
              .then((value) {})
              .onError((error, stackTrace) {
                // Utils.showSnackBar("User not updated", Colors.black);
              });
        } else {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(documentSnapshot.id)
              .update({
                'dislikes': FieldValue.arrayUnion([uid]),
              })
              .then((value) {})
              .onError((error, stackTrace) {
                // Utils.showSnackBar("User not updated", Colors.black);
              });
        }

        /// remove uid from likes list when user hit dislikes
        if (docSnap['likes'].contains(uid)) {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(documentSnapshot.id)
              .update({
                "likes": FieldValue.arrayRemove([uid])
              })
              .then((value) {})
              .onError((error, stackTrace) {
                // Utils.showSnackBar("User not updated", Colors.black);
              });
        }
      });
    });
  }

  Future addCommentOnPost(int id, Comments comment) async {
    /// Create a query against the collection.
    QuerySnapshot query = await _collectionRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      _collectionRef.doc(documentSnapshot.id).get().then((docSnap) {
        _collectionRef.doc(documentSnapshot.id).update({
          'comments': FieldValue.arrayUnion([comment.toJson()]),
        }).then((value) {
          print('commented Successfully');
        }).onError((error, stackTrace) {
          print('error while comment:: $error}');
        });
      });
    });
  }

  Future updateShareField(int id, String uid, int shareValue) async {
    /// Create a reference to the cities collection
    CollectionReference postRef = _firstore.collection("posts");

    /// Create a query against the collection.
    QuerySnapshot query = await postRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      postRef.doc(documentSnapshot.id).get().then((docSnap) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(documentSnapshot.id)
            .set({
          'shares': FieldValue.arrayUnion([uid]),
          'sharesLength': shareValue
        }, SetOptions(merge: true)).then((value) {
          print('share update successfully');
        }).onError((error, stackTrace) {
          // Utils.showSnackBar("User not updated", Colors.black);
        });
      });
    });
  }

  Future deletePostFromArenaScreen(int id) async {
    /// Create a query against the collection.
    QuerySnapshot query = await _collectionRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      _collectionRef.doc(documentSnapshot.id).delete().then((value) {
        Get.snackbar(
          'Post deleted successfully',
          '',
          colorText: Colors.white,
          backgroundColor: AppColors.disableText,
          snackPosition: SnackPosition.BOTTOM,

          // icon: const Icon(Icons.add_alert),
        );
      }).onError((error, stackTrace) {});
    });
  }

  Future editeArenaPost({
    int? id,
    String? descriptionText,
    String? headlineText,
    // String? image,
    String? postType,
  }) async {
    /// Create a reference to the cities collection
    CollectionReference postRef = _firstore.collection("posts");

    /// it will update only description and article heading if it is article post
    QuerySnapshot query = await postRef.where("id", isEqualTo: id).get();
    query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
      if (postType == 'articlePost') {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(documentSnapshot.id)
            .update({
          'postDescription': descriptionText,
          'articleHeadline': headlineText.toString(),
        }).then((value) {
          Get.offAndToNamed(routeDashboard);
          Get.snackbar(
            'Post updated successfully',
            '',
            colorText: Colors.white,
            backgroundColor: AppColors.disableText,
            snackPosition: SnackPosition.BOTTOM,
            // icon: const Icon(Icons.add_alert),
          );
          PostController().updateIsLoading(false);
        }).onError((error, stackTrace) {
          PostController().updateIsLoading(false);
          // Utils.showSnackBar("User not updated", Colors.black);
        });
      } else {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(documentSnapshot.id)
            .update({
          'postDescription': descriptionText,
        }).then((value) {
          Get.offAndToNamed(routeDashboard);
          Get.snackbar(
            'Post updated successfully',
            '',
            colorText: Colors.white,
            backgroundColor: AppColors.disableText,
            snackPosition: SnackPosition.BOTTOM,
            // icon: const Icon(Icons.add_alert),
          );
          PostController().updateIsLoading(false);
        }).onError((error, stackTrace) {
          PostController().updateIsLoading(false);
          // Utils.showSnackBar("User not updated", Colors.black);
        });
      }
    });

    ///TODO: it will be used in future, because we can also update our image or video
    /// Create a query against the collection.
    // QuerySnapshot query = await postRef.where("id", isEqualTo: id).get();
    // query.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
    //   /// imagePost
    //   if (postType == 'imagePost') {
    //     if (image != null) {
    //       FirebaseFirestore.instance
    //           .collection('posts')
    //           .doc(documentSnapshot.id)
    //           .update({
    //         'postDescription': descriptionText,
    //         'postImage': image
    //       }).then((value) {
    //         Get.offAndToNamed(routeDashboard);
    //         Get.snackbar(
    //           'Image Post updated successfully',
    //           '',
    //           colorText: Colors.white,
    //           backgroundColor: AppColors.disableText,
    //           snackPosition: SnackPosition.BOTTOM,
    //           // icon: const Icon(Icons.add_alert),
    //         );
    //         PostController().updateIsLoading(false);
    //       }).onError((error, stackTrace) {
    //         // Utils.showSnackBar("User not updated", Colors.black);
    //       });
    //     } else {
    //       FirebaseFirestore.instance
    //           .collection('posts')
    //           .doc(documentSnapshot.id)
    //           .update({
    //         'postDescription': descriptionText,
    //       }).then((value) {
    //         Get.offAndToNamed(routeDashboard);
    //         Get.snackbar(
    //           'Image Post updated successfully',
    //           '',
    //           colorText: Colors.white,
    //           backgroundColor: AppColors.disableText,
    //           snackPosition: SnackPosition.BOTTOM,
    //           // icon: const Icon(Icons.add_alert),
    //         );
    //         PostController().updateIsLoading(false);
    //       }).onError((error, stackTrace) {
    //         // Utils.showSnackBar("User not updated", Colors.black);
    //       });
    //     }
    //   }
    //
    //   /// Article Post
    //   else if (postType == 'articlePost') {
    //     if (image != null) {
    //       FirebaseFirestore.instance
    //           .collection('posts')
    //           .doc(documentSnapshot.id)
    //           .update({
    //         'postDescription': descriptionText,
    //         'articleHeadline': headlineText.toString(),
    //         'postImage': image
    //       }).then((value) {
    //         PostController().updateIsLoading(false);
    //         Get.offAndToNamed(routeDashboard);
    //         Get.snackbar(
    //           'Article Post updated successfully',
    //           '',
    //           colorText: Colors.white,
    //           backgroundColor: AppColors.disableText,
    //           snackPosition: SnackPosition.BOTTOM,
    //           // icon: const Icon(Icons.add_alert),
    //         );
    //       }).onError((error, stackTrace) {
    //         // Utils.showSnackBar("User not updated", Colors.black);
    //       });
    //     } else {
    //       FirebaseFirestore.instance
    //           .collection('posts')
    //           .doc(documentSnapshot.id)
    //           .update({
    //         'postDescription': descriptionText,
    //         'articleHeadline': headlineText.toString(),
    //   'postImage': image,
    //       }).then((value) {
    //         PostController().updateIsLoading(false);
    //         Get.offAndToNamed(routeDashboard);
    //         Get.snackbar(
    //           'Article Post updated successfully',
    //           '',
    //           colorText: Colors.white,
    //           backgroundColor: AppColors.disableText,
    //           snackPosition: SnackPosition.BOTTOM,
    //           // icon: const Icon(Icons.add_alert),
    //         );
    //       }).onError((error, stackTrace) {
    //         // Utils.showSnackBar("User not updated", Colors.black);
    //       });
    //     }
    //   }
    // });
  }
}
