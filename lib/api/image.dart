import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ImageModel {
  String? title;
  String? imageFile;

  ImageModel({this.title, this.imageFile});

  Map<String, dynamic> toJson() {
    return {"title": title, "image": imageFile};
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(title: json['title'] ?? '', imageFile: json['url']);
  }
}
