import 'package:flutter/material.dart';
import 'dart:async';

class EasyMode extends StatefulWidget {
  const EasyMode({Key? key}) : super(key: key);

  @override
  State<EasyMode> createState() => _EasyModeState();
}

class _EasyModeState extends State<EasyMode> {
  late Timer _timer;
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = 60; // Set the initial value of the counter
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--; // Decrement the counter
        });
      } else {
        timer.cancel(); // Cancel the timer when it reaches 0
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/icons/easy_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 190),
              Text(
                '${_secondsToMinutes(_counter)}',
                style: TextStyle(
                    fontFamily: 'Aero',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 24),
              ),
              SizedBox(height: 20),
              _counter != 0 ? Text('') : Text('Time\'s up!'),
            ],
          ),
        ),
      ),
    );
  }

  String _secondsToMinutes(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
