import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:meme_classifier/IndexPage.dart';

import 'package:meme_classifier/Gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meme Classifier App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Meme Classifier App' ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Container(

        decoration:  BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/Screenshot (121).png'),

                fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.lightBlueAccent.withOpacity(0.2), BlendMode.darken),


            ),
          ),

        child:  Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('MemeClassifier App'),
            centerTitle: true,
          ),
          body:SafeArea(
          child: Center(


            child: Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedTextKit(animatedTexts: [
                   WavyAnimatedText('Welcome',textStyle: const TextStyle(fontSize: 30,fontStyle: FontStyle.italic)),


                  ]),

                  ElevatedButton(onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const IndexPage()));
                  }, child: const Text('Get Started ->')),
                ],
              ),
            ),
          ),
          ),
        ),
        ),
    );
  }
}