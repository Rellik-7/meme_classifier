import 'dart:io';

import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TfliteModel extends StatefulWidget {
  List<Map> selectedlist;

  TfliteModel({Key? key, required this.selectedlist}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  late File _image;
  late List _results;
  bool isloading = true;
  bool imageSelect = false;

  @override
  void initState() {
    super.initState();
    initiateApp();
  }

  Future<void> initiateApp() async {
    //load the model
    await loadModel();

    //loop over images and analyze
    for (int i = 0; i < widget.selectedlist.length; i++) {
      final AssetEntity? asset =
          await AssetEntity.fromId(widget.selectedlist[i]['id']);
      File? imageFile = new File('');
      imageFile = await asset?.file;

      widget.selectedlist[i]['file'] = imageFile;
      var recognitions = await imageClassification(imageFile!);
      print(recognitions);
      widget.selectedlist[i]['confidence_Score'] =
          recognitions[0]['confidence'] >= 0.5
              ? recognitions[0]['confidence']
              : (1 - recognitions[0]['confidence']);
      widget.selectedlist[i]['ismeme'] =
          widget.selectedlist[i]['confidence_Score'] >= 0.9 ? true : false;
    }

    setState(() {
      isloading = false;
    });
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
    return recognitions;
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
        msg: 'All Memes deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.yellow);
  }

  Future<void> deleteallmeme() async {
    setState(() {
      isloading = true;
    });
    print(widget.selectedlist.length);
    for (int i = widget.selectedlist.length - 1; i >= 0; i--) {
      print(widget.selectedlist[i]['id']);
      if(widget.selectedlist[i]['ismeme']) {
        final List<String> result = await PhotoManager.editor
            .deleteWithIds([widget.selectedlist[i]['id']]);
        await widget.selectedlist.removeAt(i);
        showToast();
      }
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      bottomNavigationBar: Container(
        color: Colors.pinkAccent,
        child: ButtonTheme(
          buttonColor: Colors.red,
          // make buttons use the appropriate styles for cards
          child: ButtonBar(
            children: <Widget>[
              ElevatedButton(
                child: const Text('DELETE ALL MEMES'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: deleteallmeme,
              ),
            ],
          ),
        ),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: widget.selectedlist.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Card(
                        color:  widget.selectedlist[index]['ismeme'] == true?Colors.deepOrangeAccent:Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  widget.selectedlist[index]['ismeme'] == true
                                      ? 'MEME'
                                      : 'NOT A MEME',
                                  style: TextStyle(
                                      color: widget.selectedlist[index]
                                                  ['ismeme'] ==
                                              true
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1)),
                              subtitle: Text(
                                  'Meme Percentage ${widget.selectedlist[index]['confidence_Score'].toStringAsFixed(2)}'),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Image(
                                    image: FileImage(
                                        widget.selectedlist[index]['file']))),
                            ButtonTheme(
                              // make buttons use the appropriate styles for cards
                              child: ButtonBar(
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: widget.selectedlist[index]['ismeme']?Colors.red:Colors.pink
                                    ),
                                    child: const Text('Delete Image'),
                                    onPressed: () async {
                                      setState(() {
                                        isloading = true;
                                      });
                                      print(widget.selectedlist[index]['id']);
                                      final List<String> result =
                                          await PhotoManager
                                              .editor
                                              .deleteWithIds([
                                        widget.selectedlist[index]['id']
                                      ]);
                                      widget.selectedlist.removeAt(index);
                                      setState(() {
                                        isloading = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
