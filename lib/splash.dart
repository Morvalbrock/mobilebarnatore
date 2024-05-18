import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barnatore/read.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay navigation to the ReadScreen after 5 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ReadScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista e barnatoreve kujdestare',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green[700],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/splash.png")),
            SizedBox(height: 20),
            Text(
              "Barnatoret Kujdestare",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: "Netflix",
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "© AbacusSoft ",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontFamily: "Netflix",
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
