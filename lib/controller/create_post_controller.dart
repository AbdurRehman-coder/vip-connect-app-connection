import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vip_connect/model/post_model.dart';
import 'package:vip_connect/model/user_model.dart';
import 'package:vip_connect/services/create_post_firestore.dart';

class CreatePostController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // _fetchPostsData();
  }

  final postFirestore = PostsFirestoreDatebase();
  Rx<int> pollOptionIndex = 2.obs;
  addPollOptionIndex() {
    pollOptionIndex.value++;
    update();
  }

  RxList<TextEditingController> listPollTextControllers =
      <TextEditingController>[TextEditingController(), TextEditingController()]
          .obs;
  addPollTextControllers(TextEditingController textController) {
    listPollTextControllers.add(textController);
    update();
  }

  /// Post Model
  RxList<PostModel> postsModel = <PostModel>[].obs;
  setPostsModel(PostModel model) {
    postsModel.add(model);
    update();
  }

  Rx<PostModel> sharePostModel = PostModel().obs;
  setSharePostModel(PostModel model) {
    sharePostModel.value = model;
    // update();
  }

  /// User Model
  RxList<UserModel> commentUserModel = <UserModel>[].obs;
  setCommentUserModel(UserModel model) {
    // if (commentUserModel.contains(model)) {
    //   print('comment model already contain');
    // } else {
    //   print('comment model not container');
    //   commentUserModel.add(model);
    // }
    commentUserModel.add(model);
    update();
  }

  clearCommentUserModel() {
    commentUserModel.clear();
    commentUserModel.value = [];
    update();
  }

  /// user Model
  RxList<UserModel> userModel = <UserModel>[].obs;
  setUserModel(UserModel model) {
    userModel.add(model);
    update();
  }

  /// Create posts in firestore
  Future createPost(PostModel postModel) async {
    postFirestore.createPost(postModel);
  }

  /// Create posts in firestore
  Future createPoll(PostModel postModel) async {
    postFirestore.createPoll(postModel);
  }

  /// Get posts from firestore
  Future<List<PostModel>> getPostsFirestore() async {
    List<PostModel> postssModel = [];
    postFirestore.getAllPostsData().then((posts) {
      List<dynamic> dynamicPosts = posts;
      dynamicPosts.forEach((element) {
        PostModel model = PostModel.fromJson(element);
        postssModel.add(model);

        setPostsModel(model);
      });
    });
    return postssModel;
  }

  Future getUserModelForPost(String uid) async {
    postFirestore.getSingleUserData(uid).then((value) {
      if (value != null) {
        UserModel userrModel =
            UserModel.fromJson(value as Map<String, dynamic>);
        setUserModel(userrModel);
      }
    });
  }

  Future updateLikesFieldController(int id, String uid) async {
    postFirestore.updateLikesField(id, uid);
  }

  Future updateDislikesFieldController(int id, String uid) async {
    postFirestore.updateDislikeField(id, uid);
  }

  Future updateCommentFieldController(int id, Comments comment) async {
    postFirestore.addCommentOnPost(id, comment);
  }

  Future updateShareFieldController(int id, String uid, int shareValue) async {
    postFirestore.updateShareField(id, uid, shareValue);
  }

  /// vote on poll controller
  Future voteOnPollFieldController(
      int id, List<PollOptions> optionsList) async {
    postFirestore.voteOnPoll(postId: id, options: optionsList);
  }

  Future updateVotersFieldController(int id, PollsList pollsList) async {
    postFirestore.updateVotersField(id, pollsList);
  }

  Future editeArenaPostController({
    int? postId,
    String? description,
    String? articleHeadline,
    // String? imageURL,
    String? postType,
  }) async {
    postFirestore.editeArenaPost(
        id: postId,
        descriptionText: description,
        headlineText: articleHeadline,
        // image: imageURL,
        postType: postType);
  }

  final RxList<PostModel> _listPostModel = <PostModel>[].obs;
  List<PostModel> get listPostModel => _listPostModel;

  /// Fetch data from firestore collection and pass it to oue own custom model
  void _fetchPostsData() async {
    print('fetch method called...');
    final CollectionReference myCollection =
        FirebaseFirestore.instance.collection('posts');
    final QuerySnapshot snapshot =
        await myCollection.orderBy('createdAt', descending: true).get();

    final List<DocumentSnapshot> documents = snapshot.docs;
    final List<PostModel> models = documents.map((document) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      PostModel _postModelSerialization = PostModel.fromJson(data);
      return _postModelSerialization;
      // return CustomModel(
      //   title: data['title'],
      //   subtitle: data['subtitle'],
      // );
    }).toList();

    // setState(() {
    _listPostModel.clear();
    _listPostModel.addAll(models);
    // });
    print('_listPostModel length: ${_listPostModel.length}');
    myCollection.snapshots().listen((snapshot) {
      print('listening called....');
      _listPostModel.clear();
      snapshot.docChanges.forEach((docChange) {
        final DocumentSnapshot document = docChange.doc;
        switch (docChange.type) {
          case DocumentChangeType.added:
            final Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
            PostModel model = PostModel.fromJson(data);

            // final PostModel model = PostModel(
            //   title: data['title'],
            //   subtitle: data['subtitle'],
            // );
            // setState(() {
            _listPostModel.add(model);
            // });
            break;
          case DocumentChangeType.modified:
            final Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
            PostModel model = PostModel.fromJson(data);
            // final CustomModel model = CustomModel(
            //   title: data['title'],
            //   subtitle: data['subtitle'],
            // );
            final int index =
                _listPostModel.indexWhere((item) => item.id == model.id);
            // setState(() {
            _listPostModel[index] = model;
            // });
            break;
          case DocumentChangeType.removed:
            final Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
            final String id = data['id']!;
            // setState(() {
            _listPostModel.removeWhere((item) => item.id == id);
            // });
            break;
        }
      });
    });
  }
}
