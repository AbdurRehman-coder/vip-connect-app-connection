import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBadgeWidget extends StatelessWidget {
  final String chatRoomId;

  ChatBadgeWidget({required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: getUnreadMessageCountStream(chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        final unreadCount = snapshot.data ?? 0;

        return unreadCount == 0
            ? const Text('')
            : CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 12,
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }

  Stream<int> getUnreadMessageCountStream(String chatRoomId) {
    final chatRoomRef =
        FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId);

    return chatRoomRef.collection('messages').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['status'] == 'unread')
          .length;
    });
  }
}
