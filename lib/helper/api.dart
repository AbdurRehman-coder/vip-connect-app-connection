import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

import '../constants.dart';
import '../utils/util.dart';

class ApiHelper {
  // static String baseUrl = kLiveBaseUrl;
  static String baseUrl = kDevBaseUrl;

  static String kLogin = "login";

  static Map<String, Uri> getApiUrls() {
    return <String, Uri>{
      kLogin: Uri.parse("${baseUrl}auth/login"),
    };
  }

  static Map<String, String> defaultHeader = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language":
        "${Get.locale?.languageCode ?? ""}_${Get.locale?.countryCode ?? ""}",
  };

  // static Map<String, String> getAuthHeader() {
  //   AuthController authController = Get.find();
  //   String token = authController.token.value;
  //   return <String, String>{
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //     "Accept-Language":
  //         "${Get.locale?.languageCode ?? ""}_${Get.locale?.countryCode ?? ""}",
  //     "Authorization": "Bearer $token"
  //   };
  // }

  Future<dynamic> get(
      String apiName, Uri uri, Map<String, String>? header) async {
    log("Header = $header");
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        http.Response response = await http.get(
          uri,
          headers: header ?? ApiHelper.defaultHeader,
        );
        log("API => Get => Link => ${uri.toString()}");
        bool responseGood = await responseIsGoodCheck(apiName, response);
        if (responseGood) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      } catch (e) {
        if (e.toString().contains("Failed host lookup")) {
          Util.showErrorSnackBar("internet_not_available".tr);
          return null;
        }
      }
    } else {
      return null;
    }
  }

  Future<dynamic> put(String apiName, Uri uri, Map<String, String>? header,
      Map<String, dynamic>? body) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        http.Response response = await http.put(uri,
            headers: header ?? ApiHelper.defaultHeader, body: body);

        log("API => Put => Link => ${uri.toString()}");
        bool responseGood = await responseIsGoodCheck(apiName, response);
        if (responseGood) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      } catch (e) {
        if (e.toString().contains("Failed host lookup")) {
          Util.showErrorSnackBar("internet_not_available".tr);
          return null;
        }
      }
    } else {
      return null;
    }
  }

  Future<dynamic> delete(
      String apiName, Uri uri, Map<String, String>? header) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        http.Response response = await http.delete(
          uri,
          headers: header ?? ApiHelper.defaultHeader,
        );
        log("API => Delete => Link => ${uri.toString()}");

        bool responseGood = await responseIsGoodCheck(apiName, response);
        if (responseGood) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      } catch (e) {
        if (e.toString().contains("Failed host lookup")) {
          Util.showErrorSnackBar("internet_not_available".tr);
          return null;
        }
      }
    } else {
      return null;
    }
  }

  Future<dynamic> post(String apiName, Uri uri, Map<String, String>? header,
      Map<String, dynamic> body) async {
    log("Body = $body");
    log("Header = ${header ?? ApiHelper.defaultHeader}");
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        http.Response responseData = await http.post(
          uri,
          headers: header ?? ApiHelper.defaultHeader,
          body: jsonEncode(body),
        );
        log("API => Post => Link => ${uri.toString()}");
        bool responseGood = await responseIsGoodCheck(apiName, responseData);
        if (responseGood) {
          return jsonDecode(responseData.body);
        } else {
          return null;
        }
      } catch (e) {
        if (e.toString().contains("Failed host lookup")) {
          Util.showErrorSnackBar("internet_not_available".tr);
          return null;
        }
      }
    } else {
      return null;
    }
  }

  Future<dynamic> imageUpload(Uri uri, Map<String, String>? header,
      File imageFile, Map<String, String>? fieldsData) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        String temp = p.extension(imageFile.path).replaceAll(".", "");
        http.MultipartRequest request = http.MultipartRequest("POST", uri);
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType(
            'image',
            temp,
          ),
        );
        if (fieldsData != null) {
          request.fields.addAll(fieldsData);
        }
        request.files.add(multipartFile);
        request.headers.addAll(header!);

        http.StreamedResponse streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        print(response.body);
        return jsonDecode(response.body);
      } catch (e) {
        if (e.toString().contains("Failed host lookup")) {
          Util.showErrorSnackBar("internet_not_available".tr);
          return null;
        }
      }
    } else {
      return null;
    }
  }

  Future<bool> responseIsGoodCheck(
      String apiName, http.Response response) async {
    if (response.statusCode == 404) {
      log("********* Response 404 *********");
      log("$apiName\n${response.body}");
      return false;
    } else if (response.statusCode == 422) {
      log("********* Response 422 *********");
      log("$apiName\n${response.body}.");
      return true;
    } else if (response.statusCode == 400) {
      log("********* Response 400 *********");
      log("$apiName\n${response.body}.");
      return true;
    } else if (response.statusCode == 403) {
      log("********* Response 403 *********");
      log("$apiName\n${response.body}.");
      return true;
    } else if (response.statusCode == 401) {
      log("********* Response 401 *********");
      log("$apiName\n${response.body}.");
      // AuthController authController = Get.find();
      // await authController.logoutLocally();
      // Get.offAllNamed(routeSplash);
      return true;
    } else if (response.statusCode == 200) {
      log("********* Response Is Good *********");
      log("$apiName\n${response.body}.");
      return true;
    } else if (response.statusCode == 202) {
      log("********* Response Is Good *********");
      log("$apiName\n${response.body}.");
      return true;
    } else {
      log("********* Response ${response.statusCode} UnConfigure *********");
      log("$apiName\n${response.body}");
      return false;
    }
  }

  Future<bool> internetAvailabilityCheck(bool fromInternetCheckScreen) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      // Util.showErrorSnackBar("internet_not_available".tr);
      // if (fromInternetCheckScreen == false) {
      //   Get.offAllNamed(routeInternetNotAvailable);
      // }
      return false;
    }
  }
}
