import 'package:appdev/models/card.dart';
import 'package:appdev/pages/card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<Cards> _cards;
  late List<Cards> _validPairs;
  late Cards? _tappedCard;
  late Timer _timer;
  late int _counter;
  bool _enableTaps = false;

  @override
  void initState() {
    super.initState();
    _counter = 60;
    _cards = getRandomCards(16);
    _tappedCard = null;
    _validPairs = [];
    _startTimer();
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
    if (card.isMatched || card == _tappedCard) {
      // Do nothing if the card is already matched
      return;
    }
    card.isTapped = true;
    setState(() {
      if (_tappedCard == null) {
        _tappedCard = card;
      } else {
        if (_tappedCard!.id == card.id) {
          // If cards match (have the same ID), mark them as matched and remove them
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columns = screenWidth > 600 ? 5 : 4;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/icons/bg_game.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 65,
            ),
            Container(
              width: 230,
              height: 120,
              child: Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
            ),
            Text(
              '${_secondsToMinutes(_counter)}',
              style: TextStyle(
                fontFamily: 'Aero',
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: columns,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.7,
                    children: _cards.map((card) {
                      if (card.isMatched) {
                        return Container();
                      } else {
                        return CardWidget(card: card, onTap: handleCardTap);
                      }
                    }).toList(),
                  ),
                ),
              ),
            ),
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
