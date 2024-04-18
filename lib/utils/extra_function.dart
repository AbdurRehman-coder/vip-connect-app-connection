import 'package:flutter/material.dart';
import 'package:get/get.dart';

String? emailValidator(String? value, String? validationError) {
  value = value.toString().trim();

  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field".tr;
  } else if (!value.contains("@") || !value.contains(".")) {
    return 'invalid_email'.tr;
  } else if (value.contains(" ")) {
    return 'email_contain_white_space'.tr;
  }
  return null;
}

String? emailValidatorForProfile(String? value, String? validationError) {
  value = value.toString().trim();

  if (value == 'null' || value.isEmpty) {
    return null;
  } else if (!value.contains("@") || !value.contains(".")) {
    return 'invalid_email'.tr;
  }
  return null;
}

String? passwordValidator(String? value, String? validationError) {
  value = value.toString().trim();
  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field".tr;
  } else if (value.length < 6) {
    return "password_must_greater_than_6".tr;
  }
  return null;
}

String? phoneValidator(String? value, String? validationError) {
  value = value.toString().trim();
  String temp;
  if (value.contains("+")) {
    temp = value.replaceAll("+", "");
  } else {
    temp = value;
  }
  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field".tr;
  } else if (!temp.isNumericOnly) {
    return "phone_no_should_be_number_only".tr;
  } else if (value.length != 8) {
    return "phone_no_should_be_12".tr;
  } else {
    return null;
  }
}

String? simpleValidator(String? value, String? validationMsg) {
  value = value.toString().trim();
  if (value == 'null' || value.isEmpty) {
    return validationMsg ?? "empty_field".tr;
  }
  return null;
}

Future<DateTime?> pickDateAndAssign(
    BuildContext context, bool startFromToday, bool endDateToday) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: startFromToday ? DateTime.now() : DateTime(1900, 1),
      lastDate: endDateToday ? DateTime.now() : DateTime(2101));
  if (picked != null) {
    return picked;
  } else {
    return null;
  }
}

// launchUrlFromUri(Uri url) async {
//   if (await canLaunchUrl(url)) {
//     await launchUrl(url);
//   } else {
//     if (kDebugMode) {
//       print('Could not open this url = $url');
//     }
//   }
// }
