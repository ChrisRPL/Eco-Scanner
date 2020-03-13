import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home_page.dart';


void main() =>  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp()
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      backgroundColor: Colors.lightGreen,
      image: Image.asset("assets/loadingBunny.png"),
      loaderColor: Colors.white,
      photoSize: 100.0,
      navigateAfterSeconds: HomePage(),
      title: Text("Eco Scanner", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 40, fontFamily: "OpenSans", color: Colors.white, shadows: [
        Shadow(
          blurRadius: 3.0,
          color: Colors.black12,
          offset: Offset(3.0, 3.0),
        ),
      ],)),


    );
  }
}


