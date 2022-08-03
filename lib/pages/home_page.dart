import 'package:adding_image_server/api/image.dart';
import 'package:adding_image_server/api/service.dart';
import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _addFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("PATH:    ${_image!.path}");
      } else {
        print("No image selected");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colours.swatch('e3b100'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: GestureDetector(
          onTap: () {
            print(_image!.path);
          },
          child: Form(
            key: _addFormKey,
            child: Container(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: _titleController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'Field can not be empty';
                        }
                      },
                      decoration:
                          InputDecoration(hintText: "Загаловок картинки"),
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        getImage();
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Camera")),
                  if (_image != null)
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _image = null;
                          });
                        },
                        child: Text("Delete image")),
                  if (_image != null)
                    Container(
                      width: 100,
                      height: 200,
                      child: Image.file(_image!),
                    ),
                  if (_image != null)
                    OutlinedButton.icon(
                        onPressed: () async {
                          if (!_addFormKey.currentState!.validate()) {
                            return;
                          }
                          Map<String, String> body = {
                            "title": _titleController.text,
                          };
                          await Service.addImage(body, _image!.path);
                        },
                        icon: Icon(Icons.send),
                        label: Text("Send")),
                  SizedBox(
                    height: 50,
                  ),
                  FutureBuilder<List<ImageModel>>(
                      future: Service().getImages(),
                      builder: (context, snap) {
                        bool checkConnection =
                            snap.connectionState == ConnectionState.done;
                        if (!checkConnection) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snap.hasError) {
                          return Text("${snap.error}");
                        } else if (snap.data == null) {
                          return Text("Empty");
                        } else if (snap.data!.isEmpty) {
                          return Text("Empty");
                        } else {
                          return Expanded(
                              child: ListView.builder(
                                  itemCount: snap.data!.length,
                                  itemBuilder: (contextm, index) {
                                    var each = snap.data![index];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text("${each.title}"),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                              "${Service.imageURL}${each.imageFile}"),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              GallerySaver.saveImage(
                                                  "${Service.imageURL}${each.imageFile}",
                                                  toDcim: true);
                                            },
                                            icon: Icon(Icons
                                                .vertical_align_bottom_sharp))
                                      ],
                                    );
                                  }));
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
