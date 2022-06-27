import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_classifier/photo_manager.dart';

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
      body:Container(
        child: Center(
          child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GridGallery()));
            },
            child: Text('Open Gallery'),


          ),
        ),
      ),
    );
  }
}
