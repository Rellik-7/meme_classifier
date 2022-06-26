import 'dart:io';

import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class gallary extends StatefulWidget {
  const gallary({Key? key}) : super(key: key);

  @override
  _gallaryState createState() => _gallaryState();
}

class _gallaryState extends State<gallary> {
  File? singleImage;

  final singlePicker = ImagePicker();
  final multiPicker = ImagePicker();
  List<XFile>? images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallary'),centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  getSingleImage();
                },
                child: singleImage == null
                    ? Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      )),
                  width: 100,
                  height: 100,
                  child: const Icon(
                    CupertinoIcons.camera,
                    color: Colors.grey,
                  ),
                )
                    : Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      )),
                  width: 100,
                  height: 100,
                  child: Image.file(
                    singleImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('You Can Add Phoots Here'),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    getMultiImages();
                  },

                  child: GridView.builder(

                      itemCount: images!.isEmpty ? 1 : images!.length,

                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5))),
                          child: images!.isEmpty
                              ? Icon(
                            CupertinoIcons.camera,
                            color: Colors.grey.withOpacity(0.5),
                          )
                              : Image.file(
                            File(images![index].path),

                            fit: BoxFit.cover,


                          ))

                  ),
                ),

              )
            ],
          ),
        ),
      ),
    );
  }

  Future getSingleImage() async {
    final pickedImage =
    await singlePicker.getImage(source: (ImageSource.gallery));
    setState(() {
      if (pickedImage != null) {
        singleImage = File(pickedImage.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  Future getMultiImages() async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage();
    setState(() {
      if (selectedImages!.isNotEmpty) {
        images!.addAll(selectedImages);
      } else {
        if (kDebugMode) {
          print('No Images Selected ');
        }
      }
    });
  }
}