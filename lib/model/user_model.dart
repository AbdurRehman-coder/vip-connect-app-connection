import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? fullName;
  String? jobTitle;
  String? employerName;
  String? cityName;
  String? stateName;
  String? bio;
  String? industry;
  String? userEmail;
  String? profileImage;
  String? uid;
  String? fcmToken;
  Timestamp? createdAt;
  bool? isEmailVerified;
  List<String>? acceptedConnections;

  UserModel({
    this.firstName,
    this.lastName,
    this.fullName,
    this.jobTitle,
    this.employerName,
    this.cityName,
    this.stateName,
    this.bio,
    this.industry,
    this.userEmail,
    this.profileImage,
    this.uid,
    this.fcmToken,
    this.createdAt,
    this.isEmailVerified,
    this.acceptedConnections,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    jobTitle = json['jobTitle'];
    employerName = json['employerName'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    bio = json['bio'];
    industry = json['industry'];
    userEmail = json['userEmail'];
    profileImage = json['profileImage'];
    uid = json['uid'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    isEmailVerified = json['isEmailVerified'];
    acceptedConnections = json['acceptedConnections'] != null
        ? json['acceptedConnections'].cast<String>()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['fullName'] = fullName;
    data['jobTitle'] = jobTitle;
    data['employerName'] = employerName;
    data['cityName'] = cityName;
    data['stateName'] = stateName;
    data['bio'] = bio;
    data['industry'] = industry;
    data['userEmail'] = userEmail;
    data['profileImage'] = profileImage;
    data['uid'] = uid;
    data['fcmToken'] = fcmToken;
    data['createdAt'] = createdAt;
    data['isEmailVerified'] = isEmailVerified;
    data['acceptedConnections'] = acceptedConnections;
    return data;
  }
}
