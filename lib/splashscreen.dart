import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  var name = "";
  dynamic names = "";
  getData(var body) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: Home(),
        title: Text(
          "Fruit Classifier",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
            // decoration: LinearGradient(colors: Colors.amber,)
          ),
        ),
        image: Image.asset(
          'assets/fruit.png',
        ),
        gradientBackground: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.004, 1],
          colors: [Color(0xFFA8e063), Colors.purpleAccent],
        ),
        backgroundColor: Colors.black,
        photoSize: 50,
        loaderColor: Color(0xFFEEDA28),
      ),
    );
  }
}
