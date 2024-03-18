import 'dart:math';

import 'package:appdev/models/card.dart';
import 'package:appdev/pages/card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class EasyMode extends StatefulWidget {
  const EasyMode({Key? key}) : super(key: key);

  @override
  State<EasyMode> createState() => _EasyModeState();
}

class _EasyModeState extends State<EasyMode> {
  late List<Cards> _cards;
  late Timer _timer;
  late int _counter;
  late int _rows;
  late int _columns;

  @override
  void initState() {
    super.initState();
    _rows = 4;
    _columns = 4;
    _counter = 60;
    _cards = _getRandomCards(_rows * _columns);
    _startTimer();
  }

  List<Cards> _shuffleCards(List<Cards> cards) {
    Random rng = Random();
    for (int i = cards.length - 1; i >= 1; --i) {
      int newIdx = rng.nextInt(i);
      Cards temp = cards[i];
      cards[i] = cards[newIdx];
      cards[newIdx] = temp;
    }
    return cards;
  }

  List<Cards> _getRandomCards(int max) {
    Random rng = Random();
    List<String> alpha = [];
    List<Cards> cards = [];
    for (int i = 65; i <= 90; ++i) {
      alpha.add(String.fromCharCode(i));
    }
    for (int i = 0; i < max / 2; ++i) {
      int n = rng.nextInt(alpha.length);
      cards.add(Cards(val: alpha[n]));
      cards.add(Cards(val: alpha[n]));
      alpha.removeAt(n);
    }
    return _shuffleCards(cards);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel(); // Cancel the timer when it reaches 0
      }
    });
  }

  void handleCardTap(Cards card) {
    print('Card tapped: ${card.val}');
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
            _counter != 0 ? Text('') : Text(''),
            Container(
                height: MediaQuery.of(context).size.height - 250,
                child: GridView.count(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  childAspectRatio: _rows == 8 ? 0.6 : 0.7,
                  crossAxisCount: _rows == 8 ? 5 : _rows,
                  mainAxisSpacing: _rows == 6 ? 35.0 : 20.0,
                  crossAxisSpacing: _rows == 6 ? 10.0 : 20.0,
                  children: _cards
                      .map((card) =>
                          CardWidget(card: card, onTap: handleCardTap))
                      .toList(),
                )),
          ],
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
