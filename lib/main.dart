import 'package:adding_image_server/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  runApp(MaterialApp(
    // Plugin must be initialized before using
    home: HomePage(),
  ));
}
