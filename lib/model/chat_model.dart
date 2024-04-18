import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({
    this.senderId,
    this.text,
    this.chatType,
    this.imageURL,
    this.timestamp,
  });
  String? senderId;
  String? text;
  String? chatType;
  String? imageURL;
  Timestamp? timestamp;

  ChatModel.fromJson(dynamic json) {
    senderId = json['sender_id'];
    text = json['text'];
    chatType = json['chatType'];
    imageURL = json['imageURL'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sender_id'] = senderId;
    map['text'] = text;
    map['chatType'] = chatType;
    map['imageURL'] = imageURL;
    map['timestamp'] = timestamp;
    return map;
  }
}
