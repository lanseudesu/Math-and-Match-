import 'package:appdev/models/card.dart';
import 'package:appdev/pages/card_widget.dart';
import 'package:appdev/pages/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persistent storage
import 'package:appdev/models/score.dart';
import 'dart:async';
import 'dart:convert';

class Game extends StatefulWidget {
  final String difficulty;
  const Game({Key? key, required this.difficulty}) : super(key: key);
  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<Cards> _cards;
  late List<Cards> _validPairs;
  late Cards? _tappedCard;
  late Timer _timer;
  late int _rows;
  late int _columns;
  late String _difficulty;
  late int _counter;
  late int _score;
  bool _enableTaps = false;

  @override
  void initState() {
    super.initState();
    _score = 0;
    _difficulty = widget.difficulty;

    if (_difficulty.contains("Easy")) {
      _rows = 4;
      _columns = 4;
      //_counter = 300;
    } else if (_difficulty.contains("Medium")) {
      _rows = 5;
      _columns = 4;
      //_counter = 240;
    } else {
      _rows = 6;
      _columns = 5;
      //_counter = 180;
    }
    _counter = 5;
    _cards = getRandomCards(4);
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
        timer.cancel();
        _endGame(); // Cancel the timer when it reaches 0
      }
    });
  }

  void _endGame() {
    _score = _counter; // remaining time = score
    _saveScore(); // Save the score
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
          _showMatchedText();
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
    if (_cards.every((card) => card.isMatched)) {
      _timer.cancel();
      _endGame();
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

  Future<void> _saveScore() async {
    bool timerExpired = _counter == 0;

    int? storeScore = await _showConfirmationDialog(timerExpired: timerExpired);

    if (storeScore != null) {
      if (storeScore == 1) {
        // Save score
        String playerName = await _getPlayerName(context);
        final prefs = await SharedPreferences.getInstance();
        final List<String>? scoresJson = prefs.getStringList('scores');
        final List<Score> scores = scoresJson != null
            ? scoresJson
                .map((json) => Score.fromJson(jsonDecode(json)))
                .toList()
            : [];

        scores.add(Score(name: playerName, score: _score));

        // Convert list of Score objects to list of JSON strings
        final updatedScoresJson =
            scores.map((score) => score.toJsonString()).toList();

        // Save the updated scores list
        await prefs.setStringList('scores', updatedScoresJson);

        if (playerName == '_') {
          _saveScore();
        } else {
          await _showPlayAgainDialog();
        }
      } else if (storeScore == 0 || storeScore == 2) {
        bool confirmExit = await _showConfirmationExitDialog();
        if (confirmExit) {
          if (storeScore == 0) {
            //play again
            _restartGame();
            return;
          } else if (storeScore == 2) {
            //exit
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Menu()));
            return;
          }
        } else {
          _saveScore();
        }
      }
    }
  }

  Future<bool> _showConfirmationExitDialog() async {
    bool? confirmExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: AlertDialog(
            title: Text("Are you sure?"),
            content: Text("You will lose all progress."),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), //yes, continue
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
            ],
          ),
        );
      },
    );

    return confirmExit ?? false;
  }

  Future<int?> _showConfirmationDialog({bool timerExpired = false}) async {
    String title = timerExpired ? 'Game Over!' : 'Congratulations!';
    String content = timerExpired
        ? 'Haha loser, you ran out of time! :P'
        : 'You finished with ${_secondsToMinutes(_score)} time remaining';

    // Define button texts
    String playAgainText = timerExpired ? 'Try Again' : 'Play Again';
    String ExitText = timerExpired ? 'Exit' : 'Exit without Saving';

    // Define the list of buttons
    List<Widget> buttons = [
      TextButton(
        onPressed: () => Navigator.of(context).pop(0), //play again
        child: Text(playAgainText),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(2), //save
        child: Text(ExitText),
      ),
    ];

    // Add the "Exit Without Saving" button if the timer hasn't expired
    if (!timerExpired) {
      buttons.add(
        TextButton(
          onPressed: () => Navigator.of(context).pop(1), //exit
          child: Text("Save Score"),
        ),
      );
    }

    return await showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: buttons,
          ),
        );
      },
    );
  }

  Future<String> _getPlayerName(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: AlertDialog(
            title: Text('Enter Your Name'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Your Name"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop('_'); // Go back to the confirmation dialog
                },
                child: Text('Cancel'),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPlayAgainDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: AlertDialog(
            title: Text("Do you want to play again?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Menu()));
                },
                child: Text("No"),
              ),
              TextButton(
                onPressed: () {
                  _restartGame();
                  Navigator.of(context).pop();
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      if (_difficulty.contains("Easy")) {
        _counter = 300;
      } else if (_difficulty.contains("Medium")) {
        _counter = 240;
      } else {
        _counter = 180;
      }
      _score = 0;
      _cards = getRandomCards(_rows * _columns);
      _tappedCard = null;
      _validPairs = [];
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                child:
                    Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
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
                      crossAxisCount: _columns,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio:
                          MediaQuery.of(context).size.width > 600 ? 0.6 : 0.7,
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
      ),
    );
  }

  String _secondsToMinutes(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exit Game"),
              content: Text("Are you sure you want to exit the game?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the main menu
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Menu()),
                    );
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
