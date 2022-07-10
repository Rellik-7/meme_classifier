import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_classifier/Gallery.dart';
import 'package:meme_classifier/TfliteModel.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Index Page'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GridGallery()));
                },
                child: Text('Open Gallery'),
              ),
            ),
          ),
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TfliteModel()));
                },
                child: Text('Predict Meme'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
