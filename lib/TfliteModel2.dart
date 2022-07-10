import 'dart:io';

import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_forest/icon_forest.dart';
class TfliteModel extends StatefulWidget {
  final List<Map> selectedlist;

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
    print('started');
    //load the model
    await loadModel();

    //loop over images and analyze
    for (int i = 0; i < widget.selectedlist.length; i++) {
      final AssetEntity? asset =
      await AssetEntity.fromId(widget.selectedlist[i]['id']);
      File? imageFile = new File('');
      imageFile = await asset?.file;

      widget.selectedlist[i]['file'] = imageFile;
      widget.selectedlist[i]['confidence_score'] = 0.02;
      widget.selectedlist[i]['meme'] = true;

      // await imageClassification(imageFile!);
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
    print(recognitions);
    // setState(() {
    //   _results = recognitions!;
    //   print
    //   (_results);
    //   _image = image;
    //   imageSelect = true;
    // });
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
        textColor: Colors.yellow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: isloading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: widget.selectedlist.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(10) ,
            child: Column(
              children: <Widget>[
                Card(
                  elevation:5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(

                        title: Text(widget.selectedlist[index]['ismeme']==true?'MEME':'NOT A MEME',style:TextStyle(color:widget.selectedlist[index]['ismeme']==true?Colors.red:Colors.green ,fontWeight: FontWeight.w800,letterSpacing: 1)),
                        subtitle: Text('Meme Percentage ${widget.selectedlist[index]['confidence_Score']}'),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Image(image: FileImage(widget.selectedlist[index]['file']))
                      )
                      ,
                      ButtonTheme( // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('Flutter'),
                              onPressed: () { /* ... */ },
                            ),
                            FlatButton(
                              child: const Text('Show More'),
                              onPressed: () { /* ... */ },
                            ),                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },),
    );
  }
}
