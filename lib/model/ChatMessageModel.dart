class ChatMessageModel {
  ChatMessageModel({
    this.message,
    this.from,
  });

  ChatMessageModel.fromJson(dynamic json) {
    message = json['message'];
    from = json['from'];
  }
  String? message;
  String? from;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['from'] = from;
    return map;
  }
}
