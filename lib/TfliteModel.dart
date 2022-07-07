import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({Key? key}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  late File _image;
  late List _results;
  bool imageSelect = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model:
            "assets/models/mobilenetv2_preprocessed_model_adam_20epoch_addedall.tflite",
        labels: "assets/models/memelabels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.00,
      // imageMean: 0.0,
      // imageStd: 255.0,
    );
    setState(() {
      _results = recognitions!;
      print(_results);
      _image = image;
      imageSelect = true;
    });
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error in accessing file");
    }
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Image Deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.yellow
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: ListView(
        children: [
          (imageSelect)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  height: 400,
                  child: Image.file(_image),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: const Opacity(
                    opacity: 0.8,
                    child: Center(
                      child: Text("No image selected"),
                    ),
                  ),
                ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)
                  ? _results.map((result) {
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: result['confidence'] >= 0.5
                              ? Text(
                                  "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 20),
                                )
                              : Text(
                                  "Meme - ${(1 - result['confidence']).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                        ),
                      );
                    }).toList()
                  : [],
            ),
          ),
          (imageSelect) ? Container(
            child: Center(
              child: ElevatedButton(
                onPressed: (){
                  print(_image.path);
                  deleteFile(_image);
                  showToast();
                  Navigator.pop(context);
                },
                child: Text('Delete image'),
              ),
            ),
          ) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    print(pickedFile!.path);
    // FilePickerResult? pickedFilePath = await FilePicker.platform.pickFiles(type: FileType.image);
    // print(pickedFilePath!.files.single.path!);
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}
