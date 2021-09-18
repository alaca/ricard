import 'package:flutter/material.dart';

class Splash extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: Hero(
              tag: 'splash',
              child: Image.asset(
                  'assets/images/ricard.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover
              )
          ),
        ),
      ),
    );
  }
}