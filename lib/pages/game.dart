import 'package:appdev/main.dart';
import 'package:appdev/models/audio.dart';
import 'package:appdev/models/card.dart';
import 'package:appdev/pages/card_widget.dart';
import 'package:appdev/pages/main_menu.dart';
import 'package:appdev/utils/size_config.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:appdev/models/players.dart';
import 'dart:async';

class Game extends StatefulWidget {
  final String difficulty;
  final List<Player>? users;

  const Game({Key? key, this.users, required this.difficulty})
      : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<Cards> _cards;
  late Cards? _tappedCard;
  late Timer _timer;
  late int _rows;
  late int _columns;
  late String _difficulty;
  late int _counter;
  late int _score;
  bool _enableTaps = false;
  late String _loggedInUser;
  bool _isMounted = false;
  List<Player> users = [];

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadUsers();
    _score = 0;
    _difficulty = widget.difficulty;
    _loggedInUser =
        Provider.of<UserState>(context, listen: false).loggedInUser ??
            ''; //get loggedin user

    if (_difficulty.contains("Easy")) {
      _rows = 4;
      _columns = 4;
      _counter = 300;
      _cards = getRandomCards(_rows * _columns, end: 16);
    } else if (_difficulty.contains("Medium")) {
      _rows = 5;
      _columns = 4;
      _counter = 240;
      _cards = getRandomCards(_rows * _columns, start: 16, end: 36);
    } else if (_difficulty.contains("Hard")) {
      _rows = 6;
      _columns = 5;
      _counter = 180;
      _cards = getRandomCards(_rows * _columns, start: 36, end: 66);
    }
    _tappedCard = null;
    _startTimer();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  //fetch data from db
  void _loadUsers() {
    Player.fetchData().then((data) {
      if (_isMounted) {
        setState(() {
          users = data;
        });
      }
    });
  }

  List<Player> getLoggedInUserScores() {
    return getUniqueUsersWithHighestScores(_loggedInUser);
  }

  //get scores of logged in user
  List<Player> getUniqueUsersWithHighestScores(String loggedInUsername) {
    Map<String, Player> uniqueUsers = {};

    for (Player user in users) {
      if (!uniqueUsers.containsKey(user.username)) {
        uniqueUsers[user.username] = user;
      } else {
        Player existingUser = uniqueUsers[user.username]!;
        if (user.easyScore > existingUser.easyScore) {
          uniqueUsers[user.username] = Player(
            username: user.username,
            easyScore: user.easyScore,
            mediumScore: existingUser.mediumScore,
            hardScore: existingUser.hardScore,
          );
        }
        if (user.mediumScore > existingUser.mediumScore) {
          uniqueUsers[user.username] = Player(
            username: user.username,
            easyScore: existingUser.easyScore,
            mediumScore: user.mediumScore,
            hardScore: existingUser.hardScore,
          );
        }
        if (user.hardScore > existingUser.hardScore) {
          uniqueUsers[user.username] = Player(
            username: user.username,
            easyScore: existingUser.easyScore,
            mediumScore: existingUser.mediumScore,
            hardScore: user.hardScore,
          );
        }
      }
    }

    return uniqueUsers.values.toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;

          if (_counter == 6 && AudioUtil.isSounds) {
            FlameAudio.play('8seconds.mp3', volume: AudioUtil.soundVolume * 13);
          }
        });
      } else {
        //timer runs out
        timer.cancel();
        _endGame();
      }
    });
  }

  void _endGame() {
    bool timerExpired = _counter == 0;

    if (timerExpired) {
      //timer expires
      FlameAudio.play('cry.mp3', volume: AudioUtil.soundVolume * 13);
    } else {
      FlameAudio.play('applause.mp3', volume: AudioUtil.soundVolume * 13);
    }
    _score = _counter; //remaining time = score
    _saveScore(_difficulty); //save score
  }

  void handleCardTap(Cards card) {
    if (_counter == 0) {
      return;
    }
    if (card.isMatched || card == _tappedCard) {
      //do nothing if card already matched
      return;
    }
    card.isTapped = true;
    setState(() {
      if (_tappedCard == null) {
        _tappedCard = card;
      } else {
        if (_tappedCard!.id == card.id) {
          //if cards match, mark them as match
          List<String> audioFiles = [
            //random audiofiles for matched cards
            '1.mp3',
            '2.mp3',
            '3.mp3',
            '4.mp3',
            '5.mp3',
            '6.mp3',
            '7.mp3'
          ];
          audioFiles.shuffle();
          FlameAudio.play(audioFiles.first, volume: AudioUtil.soundVolume * 13);
          _tappedCard!.isMatched = true;
          card.isMatched = true;
          _tappedCard = null;
        } else {
          //flip cards back if they do not match
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
      _timer.cancel(); //all cards are matched -> end game
      _endGame();
    }
  }

  Future<void> _saveScore(String difficulty) async {
    bool timerExpired = _counter == 0;

    int? storeScore;
    if (timerExpired) {
      storeScore = await _showGameOverDialog();
    } else {
      storeScore = await _showCongratulationsDialog();
    }

    if (storeScore != null) {
      if (storeScore == 1) {
        _showPlayAgainDialog();

        String loggedInUser =
            Provider.of<UserState>(context, listen: false).loggedInUser ?? '';

        //saving of score to db
        if (difficulty == 'Easy') {
          try {
            //fetch player data
            List<Player> players = await Player.fetchData();

            //find player w/ the username
            Player? player = players.firstWhere(
              (player) => player.username == loggedInUser,
              orElse: () => Player(
                  username: loggedInUser,
                  easyScore: 0,
                  mediumScore: 0,
                  hardScore: 0),
            );

            int? easyScore = player.easyScore;
            int? mediumScore = player.mediumScore;
            int? hardScore = player.hardScore;
            print('Score: $_score, Easy Score: $easyScore');
            if (_score >= easyScore) {
              await Player.addUserData(
                  loggedInUser, _score, mediumScore, hardScore);
            }
          } catch (e) {
            print('Error: $e');
          }
        } else if (difficulty == 'Medium') {
          try {
            List<Player> players = await Player.fetchData();

            Player? player = players.firstWhere(
              (player) => player.username == loggedInUser,
              orElse: () => Player(
                  username: loggedInUser,
                  easyScore: 0,
                  mediumScore: 0,
                  hardScore: 0),
            );

            int? easyScore = player.easyScore;
            int? mediumScore = player.mediumScore;
            int? hardScore = player.hardScore;

            if (_score >= mediumScore) {
              await Player.addUserData(
                  loggedInUser, easyScore, _score, hardScore);
            } else {
              print('lower score');
            }
          } catch (e) {
            print('Error: $e');
          }
        } else if (difficulty == 'Hard') {
          try {
            List<Player> players = await Player.fetchData();

            Player? player = players.firstWhere(
              (player) => player.username == loggedInUser,
              orElse: () => Player(
                  username: loggedInUser,
                  easyScore: 0,
                  mediumScore: 0,
                  hardScore: 0),
            );

            int? easyScore = player.easyScore;
            int? mediumScore = player.mediumScore;
            int? hardScore = player.hardScore;

            if (_score >= mediumScore) {
              await Player.addUserData(
                  loggedInUser, easyScore, mediumScore, _score);
            } else {}
          } catch (e) {
            print('Error: $e');
          }
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
          _saveScore(difficulty);
        }
      }
    }
  }

  void _showPlayAgainDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                width: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff9C51E8).withOpacity(1),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(8, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Color(0xffFFBEF3).withOpacity(1),
                    width: 8,
                  ),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 10),
                  Stack(children: [
                    Text('Do you want to \nplay again?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Color(0xffA673DE),
                        )),
                    Text('Do you want to \nplay again?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Colors.white,
                        )),
                  ]),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _restartGame();
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Color(0xffA673DE))),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text("    YES     ",
                          style: TextStyle(
                              fontFamily: 'Catfiles',
                              fontWeight: FontWeight.w500,
                              color: Color(0xffA673DE),
                              fontSize: 12)),
                    ),
                    SizedBox(width: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Menu()));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff9C51E8)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text("      NO      ",
                          style: TextStyle(
                              fontFamily: 'Catfiles',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12)),
                    ),
                  ]),
                  SizedBox(height: 15),
                ])));
      },
    );
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
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                width: 400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff9C51E8).withOpacity(1),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(8, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Color(0xffFFBEF3).withOpacity(1),
                    width: 8,
                  ),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 10),
                  Stack(children: [
                    Text('Are you sure?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Color(0xffA673DE),
                        )),
                    Text('Are you sure?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white,
                        )),
                  ]),
                  SizedBox(height: 10),
                  Text(
                    "You will lose all progress.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Catfiles',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff9C51E8)),
                  ),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Color(0xffA673DE))),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ), //yes, continue
                      child: Text("    YES     ",
                          style: TextStyle(
                              fontFamily: 'Catfiles',
                              fontWeight: FontWeight.w500,
                              color: Color(0xffA673DE),
                              fontSize: 12)),
                    ),
                    SizedBox(width: 15),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff9C51E8)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text("      NO      ",
                          style: TextStyle(
                              fontFamily: 'Catfiles',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12)),
                    ),
                  ]),
                  SizedBox(height: 15),
                ])),
          ),
        );
      },
    );

    return confirmExit ?? false;
  }

  Future<int?> _showGameOverDialog() async {
    return await showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.8,
              height: SizeConfig.screenHeight * 0.28,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff9C51E8).withOpacity(1),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(8, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xffFFBEF3).withOpacity(1),
                        width: 8,
                      ),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        'Haha loser, you ran out of time! :P',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9C51E8)),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: LayoutBuilder(builder: (context, constraints) {
                          double fontSize = constraints.maxWidth * 0.05;
                          double buttonWidth = constraints.maxWidth * 0.4;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {
                                    _timer.cancel();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Menu()));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xff9C51E8)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: buttonWidth * 0.1,
                                          vertical: buttonWidth * 0.08),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  child: Text('    Exit    ',
                                      style: TextStyle(
                                        fontFamily: 'Catfiles',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: fontSize,
                                      )),
                                ),
                              ),
                              SizedBox(width: 15),
                              Flexible(
                                flex: 1,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _restartGame();
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide(color: Color(0xffA673DE))),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: buttonWidth * 0.1,
                                          vertical: buttonWidth * 0.08),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  child: Text('  Try Again  ',
                                      style: TextStyle(
                                          fontFamily: 'Catfiles',
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffA673DE),
                                          fontSize: fontSize)),
                                ),
                              ),
                            ],
                          );
                        }),
                      )
                    ]),
                  ),
                  Positioned(
                      top: (SizeConfig.safeBlockVertical * 2 + 5) - 20,
                      left: SizeConfig.safeBlockHorizontal * 15 - 10,
                      child: Stack(
                        children: [
                          Text('GAME OVER!',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.safeBlockHorizontal * 8,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 5
                                  ..color = Color(0xffA673DE),
                              )),
                          Text('GAME OVER!',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.safeBlockHorizontal * 8,
                                color: Colors.white,
                              )),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<int?> _showCongratulationsDialog() async {
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    double dialogHeight = MediaQuery.of(context).size.height * 0.6;

    return await showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 500,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff9C51E8).withOpacity(1),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(8, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xffFFBEF3).withOpacity(1),
                        width: 8,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'You finished with this time remaining:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9C51E8),
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: [
                            Text(
                              '${_secondsToMinutes(_score ?? 0)}',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                fontSize: 43,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 5
                                  ..color = Color(0xffA673DE),
                              ),
                            ),
                            Text(
                              '${_secondsToMinutes(_score ?? 0)}',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                fontSize: 43,
                                color: Color(0xffFFBEF3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double fontSize = constraints.maxWidth * 0.05;
                              double buttonWidth = constraints.maxWidth * 0.3;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(0),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff9C51E8)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(
                                              horizontal: buttonWidth * 0.1,
                                              vertical: buttonWidth * 0.08),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        ' Play Again ',
                                        style: TextStyle(
                                            fontFamily: 'Catfiles',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: fontSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(1),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff9C51E8)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(
                                              horizontal: buttonWidth * 0.1,
                                              vertical: buttonWidth * 0.08),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        ' Save Score ',
                                        style: TextStyle(
                                            fontFamily: 'Catfiles',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: fontSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              );
                            },
                          ),
                        ),
                        Center(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(2),
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                  color: Color(0xffA673DE),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            child: Text(
                              '     Exit     ',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                color: Color(0xffA673DE),
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: dialogHeight / 2 - (dialogHeight * 0.3) - 28,
                    left: (dialogWidth / 2) - (dialogWidth * 0.38) - 5,
                    child: Stack(
                      children: [
                        Text(
                          'CONGRATS!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.safeBlockHorizontal * 10,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 5
                              ..color = Color(0xffA673DE),
                          ),
                        ),
                        Text(
                          'CONGRATS!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.safeBlockHorizontal * 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _restartGame() {
    _timer.cancel();
    setState(() {
      if (_difficulty.contains("Easy")) {
        _rows = 4;
        _columns = 4;
        _counter = 300;
        _cards = getRandomCards(_rows * _columns, end: 16);
      } else if (_difficulty.contains("Medium")) {
        _rows = 5;
        _columns = 4;
        _counter = 240;
        _cards = getRandomCards(_rows * _columns, start: 16, end: 36);
      } else if (_difficulty.contains("Hard")) {
        _rows = 6;
        _columns = 5;
        _counter = 180;
        _cards = getRandomCards(_rows * _columns, start: 36, end: 66);
      }
      _score = 0;
      _tappedCard = null;
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _isMounted = false;
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
                height: 15,
              ),
              Container(
                width: 150,
                height: 120,
                child:
                    Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xffFFBEF3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 253, 198, 165),
                            blurRadius: 0,
                            offset: Offset(4, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xffA673DE).withOpacity(1),
                          width: 3,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_secondsToMinutes(_counter)}',
                              style: TextStyle(
                                fontFamily: 'Aero',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Container(
                                height: 25,
                                child: TextButton(
                                  onPressed: () {
                                    _restartConfirmation(_difficulty);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xffA673DE),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(5.0),
                                  ),
                                  child: Text(
                                    'Restart',
                                    style: TextStyle(
                                      fontFamily: 'Catfiles',
                                      fontSize: 6,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            Text(
                              _difficulty.contains('Easy')
                                  ? 'EASY'
                                  : _difficulty.contains('Medium')
                                      ? 'MEDIUM'
                                      : _difficulty.contains('Hard')
                                          ? 'HARD'
                                          : '',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 5
                                  ..color = Color(0xffA673DE),
                              ),
                            ),
                            Text(
                              _difficulty.contains('Easy')
                                  ? 'EASY'
                                  : _difficulty.contains('Medium')
                                      ? 'MEDIUM'
                                      : _difficulty.contains('Hard')
                                          ? 'HARD'
                                          : '',
                              style: TextStyle(
                                fontFamily: 'Catfiles',
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Current Highscore: ${_getFormattedHighscore()}',
                          style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontWeight: FontWeight.w200,
                            fontSize: 8,
                            color: Color(0xffA673DE),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                ],
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

  Future<void> _restartConfirmation(String difficulty) async {
    bool confirmExit = await _showConfirmationExitDialog();
    if (confirmExit) {
      _restartGame();
    } else {
      return;
    }
  }

  String _secondsToMinutes(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getFormattedHighscore() {
    List<Player> loggedInUserScores = getLoggedInUserScores();
    int highestScore = 0;
    for (Player player in loggedInUserScores) {
      if (_difficulty.contains("Easy")) {
        highestScore =
            player.easyScore > highestScore ? player.easyScore : highestScore;
      } else if (_difficulty.contains("Medium")) {
        highestScore = player.mediumScore > highestScore
            ? player.mediumScore
            : highestScore;
      } else if (_difficulty.contains("Hard")) {
        highestScore =
            player.hardScore > highestScore ? player.hardScore : highestScore;
      }
    }

    //format high score in 00:00 format
    String formattedHighscore =
        '${(highestScore ~/ 60).toString().padLeft(2, '0')}:${(highestScore % 60).toString().padLeft(2, '0')}';

    return formattedHighscore;
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                    width: 300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff9C51E8).withOpacity(1),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(8, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xffFFBEF3).withOpacity(1),
                        width: 8, // Border width
                      ),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: 10),
                      Stack(children: [
                        Text('Exit Game?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Catfiles',
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 5
                                ..color = Color(0xffA673DE),
                            )),
                        Text('Exit Game?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Catfiles',
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Colors.white,
                            )),
                      ]),
                      SizedBox(height: 10),
                      Text(
                        'Are you sure? You will lose all your progress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9C51E8)),
                      ),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                _timer.cancel();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Menu()));
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: Color(0xffA673DE))),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ), //yes, continue
                              child: Text("    YES     ",
                                  style: TextStyle(
                                      fontFamily: 'Catfiles',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffA673DE),
                                      fontSize: 12)),
                            ),
                            SizedBox(width: 15),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff9C51E8)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              child: Text("      NO      ",
                                  style: TextStyle(
                                      fontFamily: 'Catfiles',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 12)),
                            ),
                          ]),
                      SizedBox(height: 15),
                    ])));
          },
        ) ??
        false;
  }
}
