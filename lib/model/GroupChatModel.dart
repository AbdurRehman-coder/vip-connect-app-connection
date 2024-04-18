import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatModel {
  GroupChatModel({
    this.id,
    this.name,
    this.lastMessage,
    this.groupImage,
    this.creator,
    this.groupId,
    this.description,
    this.isPrivate,
    this.timestamp,
    this.members,
    this.messages,
  });

  GroupChatModel.fromJson(dynamic json) {
    print('json data:: ${json}');
    // id = json['id'];
    name = json['name'];
    lastMessage = json['lastMessage'];
    groupImage = json['groupImage'];
    creator = json['creator'];
    groupId = json['groupId'];
    description = json['description'];
    isPrivate = json['isPrivate'];
    timestamp = json['timestamp'];
    members = json['members'] != null ? json['members'].cast<String>() : [];
    messages = json.toString().contains('messages')
        ? json['messages'] != null
            ? Messages.fromJson(json['messages'])
            : null
        : null;
  }
  String? id;
  String? name;
  String? lastMessage;
  String? groupImage;
  String? creator;
  String? groupId;
  String? description;
  List<String>? members;
  bool? isPrivate;
  Timestamp? timestamp;
  Messages? messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['id'] = id;
    map['name'] = name;
    map['lastMessage'] = lastMessage;
    map['groupImage'] = groupImage;
    map['creator'] = creator;
    map['groupId'] = groupId;
    map['description'] = description;
    map['isPrivate'] = isPrivate;
    map['timestamp'] = timestamp;
    map['members'] = members;
    if (messages != null) {
      map['messages'] = messages?.toJson();
    }
    return map;
  }
}

class Messages {
  Messages({
    this.id,
    this.senderId,
    this.text,
    this.timeStamp,
  });

  Messages.fromJson(dynamic json) {
    id = json['id'];
    senderId = json['senderId'];
    text = json['text'];
    timeStamp = json['timeStamp'];
  }
  String? id;
  String? senderId;
  String? text;
  Timestamp? timeStamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['senderId'] = senderId;
    map['text'] = text;
    map['timeStamp'] = timeStamp;
    return map;
  }
}
