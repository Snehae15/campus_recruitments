import 'dart:async';

import 'package:flutter/material.dart';

import 'first.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF3F6CDF), // #3F6CDF
              Color.fromRGBO(29, 106, 221, 0.92), // rgba(29, 106, 221, 0.92)
            ],
          ),
        ), // Use the navy blue color you desire
      ),
    );
  }
}
