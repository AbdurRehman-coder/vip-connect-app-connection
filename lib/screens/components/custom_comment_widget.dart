import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/app_assets.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_text_styles.dart';
import '../../model/post_model.dart';
import '../../model/user_model.dart';

class CustomCommentWidget extends StatefulWidget {
  CustomCommentWidget({Key? key, this.commentModel, this.jiffyTimeString})
      : super(key: key);
  Comments? commentModel;
  String? jiffyTimeString;

  @override
  State<CustomCommentWidget> createState() => _CustomCommentWidgetState();
}

class _CustomCommentWidgetState extends State<CustomCommentWidget> {
  UserModel? userrModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    /// Get sing user for posts
    final CollectionReference _userCollectionRef =
        FirebaseFirestore.instance.collection('user');

    /// Get user for post
    DocumentSnapshot? docSnapshot =
        await _userCollectionRef.doc(widget.commentModel?.uid).get();
    UserModel user =
        UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
    if (mounted) {
      setState(() {
        userrModel = user;
      });
    }
    print('user modeling::: ${user.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      /// Comments
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Comment user profile image
          CircleAvatar(
            /// User  picture inside post

            child: userrModel?.profileImage != null
                ? CachedNetworkImage(
                    imageUrl: userrModel!.profileImage!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          // colorFilter:
                          // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      AppAssets.logoImg,
                    ),
                  )
                : Image.asset(
                    AppAssets.logoImg,
                  ),
          ),
          SizedBox(
            width: 5.w,
          ),

          /// comment Message Container
          Expanded(
            child: Container(
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.disableButton,
              ),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Comment User Name
                    Text(
                      '${userrModel?.firstName} ${userrModel?.lastName} ',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 02,
                    ),
                    Row(
                      children: [
                        /// Designation text
                        Text(
                          userrModel?.jobTitle != null
                              ? '${userrModel?.jobTitle}'
                              : " ",
                          style: AppTextStyle.bodyMedium.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        /// Company name
                        Text(
                          userrModel?.employerName != null
                              ? ' @ ${userrModel?.employerName}'
                              : " ",
                          style: AppTextStyle.bodyMedium.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),

                    /// Company name
                    Text(
                      widget.jiffyTimeString.toString(),
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 08,
                    ),
                    Text(
                      widget.commentModel!.commentMessage.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
