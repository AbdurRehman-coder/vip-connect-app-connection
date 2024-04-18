import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom {
  final String id;
  final String user1Id;
  final String user2Id;
  ChatRoom({required this.id, required this.user1Id, required this.user2Id});
}

class User {
  final String id;
  final String displayName;
  final String photoUrl;
  User({required this.id, required this.displayName, required this.photoUrl});
}

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<ChatRoom> _chatRooms;
  late Map<String, User> _users;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
    _loadUsers();
  }

  void _loadChatRooms() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final chatRoomsRef = FirebaseFirestore.instance.collection('chat_rooms');
    final querySnapshot =
        await chatRoomsRef.where('user1_id', isEqualTo: currentUser!.uid).get();
    final chatRooms = querySnapshot.docs
        .map((doc) => ChatRoom(
            id: doc.id, user1Id: doc['user1_id'], user2Id: doc['user2_id']))
        .toList();
    setState(() {
      _chatRooms = chatRooms;
    });
  }

  void _loadUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDocs = await FirebaseFirestore.instance.collection('users').get();
    final users = userDocs.docs
        .map((doc) => User(
            id: doc.id,
            displayName: doc['display_name'],
            photoUrl: doc['photo_url']))
        .toList();
    final otherUserIds = _chatRooms
        .where((chatRoom) => chatRoom.user1Id != currentUser!.uid)
        .map((chatRoom) => chatRoom.user1Id)
        .toSet();
    final otherUsers =
        users.where((user) => otherUserIds.contains(user.id)).toList();
    final userMap = Map.fromIterable(otherUsers,
        key: (user) => user.id, value: (user) => user);
    setState(() {
      // _users = userMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_users == null) {
      return CircularProgressIndicator();
    } else {
      return ListView.builder(
        itemCount: _users.length,
        itemBuilder: (BuildContext context, int index) {
          final userId = _users.keys.elementAt(index);
          final user = _users[userId];
          return ListTile(
            leading:
                CircleAvatar(backgroundImage: NetworkImage(user!.photoUrl)),
            title: Text(user!.displayName),
            onTap: () {
              // Navigate to the chat screen with this user
            },
          );
        },
      );
    }
  }
}
