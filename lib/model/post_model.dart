import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? uid;
  String? postImage;
  String? postDescription;
  String? articleHeadline;
  String? postType;
  String? fileType;
  int? id;
  String? sharePostId;
  String? postAddress;
  // String? createdAt;
  Timestamp? createdAt;
  DateTime? pollExpireDate;
  List<String>? likes;
  List<String>? dislikes;
  List<String>? shares;
  int? sharesLength;
  List<String>? voters;
  List<Comments>? comments;
  Polls? polls;
  List<PollsList>? pollsList;
  List<PollOptions>? options;

  PostModel({
    this.uid,
    this.postImage,
    this.postDescription,
    this.articleHeadline,
    this.postType,
    this.fileType,
    this.id,
    this.sharePostId,
    this.postAddress,
    this.createdAt,
    this.pollExpireDate,
    this.likes,
    this.dislikes,
    this.shares,
    this.sharesLength,
    this.voters,
    this.comments,
    this.options,
    this.polls,
    this.pollsList,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    postImage = json['postImage'];
    postDescription = json['postDescription'];
    articleHeadline = json['articleHeadline'];
    postType = json['postType'];
    fileType = json['fileType'];
    id = json['id'];
    sharesLength = json['sharesLength'] ?? 0;
    sharePostId = json['sharePostId'];
    postAddress = json['postAddress'];
    createdAt = json['createdAt'];
    if (json['pollExpireDate'] != null) {
      pollExpireDate = json['pollExpireDate'].toDate();
    } else {
      pollExpireDate = null;
    }
    likes = json['likes'].cast<String>() ?? [];
    dislikes = json['dislikes'] != null ? json['dislikes'].cast<String>() : [];
    shares = json['shares'] != null ? json['shares'].cast<String>() : [];
    voters = json['voters'] != null ? json['voters'].cast<String>() : [];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    polls =
        polls = json['polls'] != null ? Polls.fromJson(json['polls']) : null;
    if (json['options'] != null) {
      options = <PollOptions>[];
      json['options'].forEach((v) {
        options!.add(PollOptions.fromJson(v));
      });
    }
    if (json['pollsList'] != null) {
      pollsList = <PollsList>[];
      json['pollsList'].forEach((v) {
        pollsList!.add(PollsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['postImage'] = postImage;
    data['postDescription'] = postDescription;
    data['articleHeadline'] = articleHeadline;
    data['postType'] = postType;
    data['fileType'] = fileType;
    data['id'] = id;
    data['sharesLength'] = sharesLength;
    data['sharePostId'] = sharePostId;
    data['postAddress'] = postAddress;
    data['createdAt'] = createdAt;
    data['pollExpireDate'] = pollExpireDate;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['shares'] = shares;
    data['voters'] = voters;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    if (polls != null) {
      data['polls'] = polls!.toJson();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (pollsList != null) {
      data['pollsList'] = pollsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? uid;
  String? commentMessage;
  Timestamp? createdAt;

  Comments({this.uid, this.commentMessage, this.createdAt});

  Comments.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    commentMessage = json['commentMessage'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['commentMessage'] = commentMessage;
    data['createdAt'] = createdAt;
    return data;
  }
}

class Polls {
  List<PollOptions>? pollOptions;
  List<PollsList>? pollsList;

  Polls({this.pollOptions, this.pollsList});

  Polls.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      pollOptions = <PollOptions>[];
      json['options'].forEach((v) {
        pollOptions!.add(PollOptions.fromJson(v));
      });
    }
    if (json['pollsList'] != null) {
      pollsList = <PollsList>[];
      json['pollsList'].forEach((v) {
        pollsList!.add(PollsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (pollOptions != null) {
      data['options'] = pollOptions!.map((v) => v.toJson()).toList();
    }
    if (pollsList != null) {
      data['pollsList'] = pollsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollOptions {
  int? option;
  String? optionDescription;
  int? votes;

  PollOptions({this.option, this.optionDescription, this.votes});

  PollOptions.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    optionDescription = json['optionDescription'];
    votes = json['votes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['option'] = option;
    data['optionDescription'] = optionDescription;
    data['votes'] = votes;
    return data;
  }
}

class PollsList {
  String? uid;
  int? option;
  String? duration;

  PollsList({this.uid, this.option, this.duration});

  PollsList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    option = json['option'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['option'] = this.option;
    data['duration'] = this.duration;
    return data;
  }
}

// class Polls {
//   List<Options>? options;
//   List<PollsList>? pollsList;
//
//   Polls({this.options, this.pollsList});
//
//   Polls.fromJson(Map<String, dynamic> json) {
//     if (json['options'] != null) {
//       options = <Options>[];
//       json['options'].forEach((v) {
//         options!.add(Options.fromJson(v));
//       });
//     }
//     if (json['pollsList'] != null) {
//       pollsList = <PollsList>[];
//       json['pollsList'].forEach((v) {
//         pollsList!.add(PollsList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.options != null) {
//       data['options'] = this.options!.map((v) => v.toJson()).toList();
//     }
//     if (this.pollsList != null) {
//       data['pollsList'] = this.pollsList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Options {
//   int? option;
//   String? optionDescription;
//
//   Options({this.option, this.optionDescription});
//
//   Options.fromJson(Map<String, dynamic> json) {
//     option = json['option'];
//     optionDescription = json['optionDescription'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['option'] = option;
//     data['optionDescription'] = optionDescription;
//     return data;
//   }
// }
//
// class PollsList {
//   String? uid;
//   String? option;
//   String? duration;
//
//   PollsList({this.uid, this.option, this.duration});
//
//   PollsList.fromJson(Map<String, dynamic> json) {
//     uid = json['uid'];
//     option = json['option'];
//     duration = json['duration'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['uid'] = this.uid;
//     data['option'] = this.option;
//     data['duration'] = this.duration;
//     return data;
//   }
// }
