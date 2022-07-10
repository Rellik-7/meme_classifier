import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
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
        colorScheme: ColorScheme.fromSwatch().copyWith(
          // or from RGB

          primary: const Color(0xFFFF007E),
          secondary: const Color(0xFFF590C2),
        ),
      ),
      home: const MyHomePage(title: 'Meme Classifier App'),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.lightBlueAccent.withOpacity(0.2), BlendMode.darken),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   title: const Text('MemeClassifier App'),
          //   centerTitle: true,
          // ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'MEME ClASSIFIER APP',
                      style: GoogleFonts.bangers(
                        textStyle: const TextStyle(
                            color: Colors.pinkAccent, letterSpacing: .5),
                        fontSize: MediaQuery.of(context).size.width / 7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 120),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GridGallery()));
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 100),
                          shape: const CircleBorder(),
                        ),
                        child: Text(
                          'GO!!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
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
