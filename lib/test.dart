import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestPic extends StatefulWidget {
  const TestPic({Key? key}) : super(key: key);

  @override
  State<TestPic> createState() => _TestPicState();
}

class _TestPicState extends State<TestPic> {
  final dio = Dio();

  void getHttp() async {
    final ImagePicker _picker = ImagePicker();
    print(_picker);
    // final formData = FormData.fromMap({
    //   'profilePhoto': await MultipartFile.fromFile('',
    //       filename: 'upload.png'),
    // });
    // final response = await dio.post(
    //     '/https://38cb-39-45-51-44.in.ngrok.io/api/v1/upload',
    //     data: formData);
  }

  @override
  Widget build(BuildContext context) {
    getHttp();
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: getHttp,
        child: Text(''),
      ),
    );
  }
}
