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
  late List<Cards> _validPairs;
  late Cards? _tappedCard;
  late Timer _timer;
  late int _counter;
  late int _rows;
  late int _columns;
  bool _enableTaps = false;

  @override
  void initState() {
    super.initState();
    _rows = 4;
    _columns = 4;
    _counter = 60;
    _cards = _getRandomCards(_rows * _columns);
    _tappedCard = null;
    _validPairs = [];
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
    if (_counter == 0) {
      return;
    }
    if (card.isMatched) {
      // Do nothing if the card is already matched
      return;
    }
    card.isTapped = true;
    setState(() {
      if (_tappedCard == null) {
        _tappedCard = card;
      } else {
        if (_tappedCard!.val == card.val) {
          // If cards match, mark them as matched and remove them
          _tappedCard!.isMatched = true;
          card.isMatched = true;
          _tappedCard = null;
          _showMatchedText(); // Show pop-up text for matched cards
        } else {
          // If cards don't match, flip them back
          _enableTaps = false;
          Timer(const Duration(milliseconds: 500), () {
            _tappedCard?.isTapped = false;
            card.isTapped = false;
            _tappedCard = null;
            _enableTaps = true;
          });
        }
      }
    });
    if (_validPairs.length == _cards.length ~/ 2) {
      _timer.cancel();
    }
  }

  void _showMatchedText() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Matched!'),
          content: Text('You found a match!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Cards> remainingCards =
        _cards.where((card) => !card.isMatched).toList();
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
                  children: remainingCards
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
