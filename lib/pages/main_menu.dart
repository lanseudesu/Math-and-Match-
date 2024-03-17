import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5],
          colors: [
            Colors.white,
            Color(0xffA6E0FD),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 720, child: _gameTitle()),

            // Add more widgets here if needed
          ],
        ),
      ),
    ));
  }

  Stack _gameTitle() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 180,
          child: Text(
            'MATH',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w800,
              fontFamily: 'Aero',
              letterSpacing: 2.0,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 15
                ..color = Color(0xffFF52A4),
            ),
          ),
        ),
        Positioned(
          top: 180,
          child: Text(
            'MATH',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w800,
              fontFamily: 'Aero',
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 78,
          top: 267,
          child: Text(
            'and match',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              fontFamily: 'Aero',
              letterSpacing: 3.0,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 13
                ..color = Color(0xff9C51E8),
            ),
          ),
        ),
        Positioned(
          left: 78,
          top: 267,
          child: Text(
            'and match',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              fontFamily: 'Aero',
              color: Colors.white,
              letterSpacing: 3.0,
            ),
          ),
        ),
      ],
    );
  }
}
