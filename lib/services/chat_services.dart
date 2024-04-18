import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:vip_connect/constants.dart';

class ChatServices {
  /// Send a message to a chat room
  Future<void> sendMessage({
    String? chatRoomId,
    String? senderId,
    String? receiverId,
    String? messageText,
    String? type,
    String? chatType,
    String? imageURL,
  }) async {
    /// create chat room if it doesn't exist already
    /// check if the chat room already exists
    bool chatRoomExists = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .get()
        .then((doc) => doc.exists);

    print('is chat room exist: $chatRoomExists');

    /// if the chat room doesn't exist, create it
    if (!chatRoomExists) {
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .set({
        "user1_id": senderId,
        "user2_id": receiverId,
      });
    } else {
      print('chat room already exist....');
      // sendMessage(chatRoomId, senderId, messageText)
    }

    final chatRoomRef =
        FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId);
    final messagesRef = chatRoomRef.collection('messages');
    await messagesRef.add({
      'sender_id': senderId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'chatType': chatType,
      'status': 'unread',
      'imageURL': imageURL,
    });

    /// Retrieve the recipient's user ID from the chat room document
    final chatRoomDoc = await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .get();
    // final recipientId = chatRoomDoc.get('user1Id') == senderId
    //     ? chatRoomDoc.get('user2Id')
    //     : chatRoomDoc.get('user1Id');

    /// Retrieve the recipient's FCM token from the Firestore users collection
    final recipientUserDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .get();

    /// get fcm token from user doc
    final recipientFcmToken = recipientUserDoc.get('fcmToken');

    /// pass the fcm tokens list to send the notifications
    sendNotification(
      fcmToken: [recipientFcmToken],
      title: 'VIPConnect',
      body: messageText!,
      type: type,
    );
  }

  /// Listen for new messages in a chat room
  // void listenForMessages(String chatRoomId) {
  //   final chatRoomRef =
  //       FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId);
  //   final messagesRef = chatRoomRef.collection('messages');
  //   messagesRef.orderBy('timestamp').snapshots().listen((querySnapshot) {
  //     for (final doc in querySnapshot.docs) {
  //       final senderId = doc['sender_id'];
  //       final text = doc['text'];
  //       // Process the message
  //     }
  //   });
  // }

  /// generate document inside chat_room collection by concatenating
  /// user1ID & user2ID
  String generateChatRoomId(String user1Id, String user2Id) {
    List<String> userIds = [user1Id, user2Id]..sort();
    return "${userIds[0]}-${userIds[1]}";
  }

  /// ===============================<<<<<<<<Group Chat>>>>>>>>>================== ///

  /// Create a new chat room between two users// Add a new group to Firestore
  Future<void> createGroup(
      {String? groupName,
      String? groupDescription,
      List<String>? members,
      String? groupOwnerId,
      String? groupImage,
      int? chatGroupDocLength,
      bool? isPrivate}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a new document in the "groups" collection with an automatically generated ID
    DocumentReference newGroupRef = firestore
        .collection('groupChat')
        .doc('$groupOwnerId-$groupName-$chatGroupDocLength');

    // Set the properties of the new group document
    Map<String, dynamic> data = {
      'name': groupName,
      'description': groupDescription,
      'lastMessage': ' ',
      'members': members,
      'creator': groupOwnerId,
      'groupImage': groupImage,
      'groupId': '$groupOwnerId-$groupName-$chatGroupDocLength',
      'isPrivate': isPrivate,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await newGroupRef.set(data);
  }

  Future<void> sendMessageToGroup({
    String? groupId,
    String? messageText,
    String? senderId,
    String? type,
    String? chatType,
    String? imageURL,
  }) async {
    final groupChatRoomRef =
        FirebaseFirestore.instance.collection('groupChat').doc(groupId);
    groupChatRoomRef.update(
      {
        'lastMessage': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );

    final messagesRef = groupChatRoomRef.collection('messages');
    await messagesRef.add({
      'sender_id': senderId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'chatType': chatType,
      'imageURL': imageURL,
    }).then((value) => log('group chat messages added...'));

    /// Retrieve the recipient's user ID from the chat room document
    final chatRoomDoc = await FirebaseFirestore.instance
        .collection('groupChat')
        .doc(groupId)
        .get();

    List<String> listRecipientFcmTokens = [];
    List<dynamic> recipientIds = chatRoomDoc.get('members');
    // print(
    //     'group chat recipient ids: $recipientIds ,, ${recipientIds.runtimeType}');

    /// Retrieve the recipient's FCM token from the Firestore users collection
    recipientIds.forEach((uid) async {
      /// it will sent notifications to all users except from current user itself
      if (uid != FirebaseAuth.instance.currentUser?.uid) {
        final recipientUserDoc =
            await FirebaseFirestore.instance.collection('user').doc(uid).get();
        print('user doccccc: ${recipientUserDoc.data()}');
        final recipientFcmToken = recipientUserDoc.get('fcmToken');

        /// add each user fcm token to list
        listRecipientFcmTokens.add(recipientFcmToken);
        print('recipient fcm token: $recipientFcmToken');
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      /// pass the fcm tokens list to send the notifications
      sendNotification(
          fcmToken: listRecipientFcmTokens,
          title: 'VIPConnect',
          body: messageText!,
          type: type);
    });

    // final recipientUserDoc = await FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(receiverId)
    //     .get();
    // print('user doccccc: ${recipientUserDoc.data()}');
    // final recipientFcmToken = recipientUserDoc.get('fcmToken');
    // print('recipient fcm token: $recipientFcmToken');
  }

  /// ================ Send Notification ====================
  /// TODO: this method should be moved to concern class
  Future<void> sendNotification(
      {List<String>? fcmToken,
      String? title,
      String? body,
      String? type}) async {
    /// YOUR SERVER KEY
    const String serverKey = FCMSERVERKEY;
    print('send notiifcation fcm token list: $fcmToken');

    /// FCM API FOR SENDING NOTIFICATIONS
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            // 'type': type,
            // 'payload': "$title&$body"
          },
          'priority': 'high',
          // 'to': fcmToken,
          'registration_ids': fcmToken
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
      print('notification response=== ${response.body} ,, ${response.headers}');
    } else {
      print('Error sending notification:::: ${response.body}');
    }
  }

  /// get group chat stream
  static Stream<List<QueryDocumentSnapshot>> getGroups() async* {
    final CollectionReference groupsCollection =
        FirebaseFirestore.instance.collection('groupChat');
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    // Query for all public groups, ordered by timestamp
    final QuerySnapshot publicGroupsSnapshot = await groupsCollection
        .where('isPrivate', isEqualTo: false)
        // .orderBy('timestamp', descending: true)
        .get();

    // Query for all private groups that the current user is a member of, ordered by timestamp
    final QuerySnapshot privateGroupsSnapshot = await groupsCollection
        .where('isPrivate', isEqualTo: true)
        .where('members', arrayContains: currentUserID)
        // .orderBy('timestamp', descending: true)
        .get();

    // Combine the two snapshots
    final List<QueryDocumentSnapshot> allGroups = [
      ...publicGroupsSnapshot.docs,
      ...privateGroupsSnapshot.docs
    ];

    // Sort the combined list based on privacy status
    // allGroups.sort((a, b) => a['isPrivate'].compareTo(b['isPrivate']));

    // Yield the sorted list as a stream
    yield allGroups;

    // Listen for changes to the groups collection and update the stream
    final Stream<QuerySnapshot> snapshots = groupsCollection.snapshots();
    await for (final QuerySnapshot snapshot in snapshots) {
      // Re-query for all groups and update the stream
      final QuerySnapshot publicGroupsSnapshot = await groupsCollection
          .where('isPrivate', isEqualTo: false)
          // .orderBy('timestamp', descending: true)
          .get();
      final QuerySnapshot privateGroupsSnapshot = await groupsCollection
          .where('isPrivate', isEqualTo: true)
          .where('members', arrayContains: currentUserID)
          // .orderBy('timestamp', descending: true)
          .get();
      final List<QueryDocumentSnapshot> allGroups = [
        ...publicGroupsSnapshot.docs,
        ...privateGroupsSnapshot.docs
      ];
      // allGroups.sort((a, b) => a['isPrivate'].compareTo(b['isPrivate']));
      yield allGroups;
    }
  }
}
