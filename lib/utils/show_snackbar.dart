import 'package:flutter/material.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static SnackBar showSnackBar(String? text, Color backgroundColor) {
    // if(text == null ) return;
    return SnackBar(
      content: Text(
        text!,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
