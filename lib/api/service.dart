import 'dart:convert';

import 'package:adding_image_server/api/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Service {
  static String URL = 'http://192.168.100.113:8000/api';
  static String imageURL = 'http://192.168.100.113:8000/api/storage/';
  static Future<void> addImage(
      Map<String, String> body, String filePath) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'multipart/form-data',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
      // 'Content-Type': 'application/json; charset=UTF-8',
      //   'Accept': 'application/json',
      var req = http.MultipartRequest('POST', Uri.parse('$URL/image/add'))
        ..headers.addAll(header)
        ..files.add(await http.MultipartFile.fromPath('imagejun', filePath))
        ..fields.addAll(body);

      await req.send();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<ImageModel>> getImages() async {
    List<ImageModel> imageList = [];
    try {
      var res = await http.get(Uri.parse("$URL/get/images"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      });

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        List<dynamic> list = json['images'];
        for (int i = 0; i < list.length; i++) {
          imageList.add(ImageModel.fromJson(list[i]));
        }
      }
    } catch (e) {
      print(e);
    }
    return imageList;
  }
}
