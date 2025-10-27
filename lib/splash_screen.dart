import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mindfulness_app/main.dart';
import 'package:mindfulness_app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;

  void _animate() {
    setState(() {
      _opacity = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 250), () {
      _animate();
    });
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage(title: 'Mindful Me')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 184, 164, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: Text(
                'Mindful\nMe',
                style: TextStyle(
                  color: MindfulnessTheme.offWhite,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Image.asset('assets/images/mindful.jpg'),
          ],
        ),
      ),
    );
  }
}
