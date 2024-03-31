import 'package:appdev/pages/main_menu.dart';
import 'package:appdev/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:appdev/models/players.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  List<Player> users = [];
  String currentScoreType = 'Easy';
  bool _isMounted =
      false; //indicator when widget is mounted or disposed for loading users
  int currentTopN = 0;
  List<Widget> displayedUserList = [];

  @override
  void initState() {
    super.initState();
    displayedUserList = buildUserList(currentTopN);
    _isMounted = true; //set to true for function _loadUsers
    _loadUsers();
  }

  void _loadUsers() {
    //fetch data from database
    Player.fetchData().then((data) {
      if (_isMounted) {
        setState(() {
          users = data; //fetched data is given to users
        });
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  List<Player> getUniqueUsersWithHighestScores() {
    //only get the highest scores from the same username
    Map<String, Player> uniqueUsers = {};

    for (Player user in users) {
      if (!uniqueUsers.containsKey(user.username)) {
        uniqueUsers[user.username] = user;
      } else {
        Player existingUser = uniqueUsers[user.username]!;
        if (user.easyScore > existingUser.easyScore) {
          //seperates difficulty scores of unique users
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

  List<Widget> buildUserList(int topN) {
    List<Player> uniqueUsers = getUniqueUsersWithHighestScores();

    uniqueUsers.sort((a, b) {
      //sort in descending order
      switch (currentScoreType) {
        case 'Easy':
          return b.easyScore.compareTo(a.easyScore);
        case 'Medium':
          return b.mediumScore.compareTo(a.mediumScore);
        case 'Hard':
          return b.hardScore.compareTo(a.hardScore);
        default:
          return 0;
      }
    });

    if (topN > 0) {
      uniqueUsers = uniqueUsers.take(topN).toList();
    }

    return uniqueUsers
        .asMap()
        .map((index, user) {
          late Widget leadingWidget;
          late Color backgroundColor;
          late double tileHeight;
          late double fontSize;

          switch (index) {
            case 0: //top 1 design
              leadingWidget = Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 180, 18).withOpacity(0.8),
                ),
                alignment: Alignment.center,
                child: Text('${index + 1}',
                    style: TextStyle(
                        fontFamily: 'Catfiles',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 119, 56, 4),
                        fontSize: 18)),
              );
              backgroundColor =
                  Color.fromARGB(255, 255, 238, 160).withOpacity(0.8);
              tileHeight = 62;
              fontSize = 18;
              break;
            case 1: //top 2 design
              leadingWidget = Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 226, 226, 226),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontFamily: 'Catfiles',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 65, 65, 65),
                      fontSize: 16),
                ),
              );
              backgroundColor = Color.fromARGB(255, 197, 197, 197);
              tileHeight = 57;
              fontSize = 16;
              break;
            case 2: //top 3 design
              leadingWidget = Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 153, 91, 69),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontFamily: 'Catfiles',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 183, 154),
                      fontSize: 16),
                ),
              );
              backgroundColor = Color.fromARGB(255, 214, 142, 115);
              tileHeight = 57;
              fontSize = 16;
              break;
            default: //design for the rest
              leadingWidget = Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 199, 155, 243),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontFamily: 'Catfiles',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 82, 33, 131),
                      fontSize: 16),
                ),
              );
              backgroundColor =
                  Color.fromARGB(255, 146, 81, 199).withOpacity(0.3);
              tileHeight = 53;
              fontSize = 14;
          }

          return MapEntry(
            //list design
            index,
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: tileHeight,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  leading: Container(
                    width: 40,
                    height: 40,
                    child: Center(child: leadingWidget),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${user.username}',
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w800,
                            fontSize: fontSize - 5),
                      ),
                      Text(
                        '${_getScore(user)}',
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w900,
                            fontSize: fontSize - 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        })
        .values
        .toList();
  }

  String formatScore(int score) {
    //seconds to 00:00 format
    int minutes = (score ~/ 60);
    int seconds = (score % 60);
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  String _getScore(Player user) {
    //seperate scores from each difficulty
    switch (currentScoreType) {
      case 'Easy':
        return formatScore(user.easyScore);
      case 'Medium':
        return formatScore(user.mediumScore);
      case 'Hard':
        return formatScore(user.hardScore);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Menu()));
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/icons/leaderboard-bg.png"),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              SvgPicture.asset(
                'assets/icons/trophy2.svg',
                width: 100,
              ),
              SizedBox(height: 8),
              Center(
                child: SizedBox(
                    child: Stack(
                  children: [
                    Text('LEADERBOARD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 35,
                          wordSpacing: 10,
                          shadows: [
                            Shadow(
                              offset: Offset(6, 6),
                              color: Color(0xffFFBEF3),
                              blurRadius: 0,
                            ),
                          ],
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 7
                            ..color = Color(0xff6D027C),
                        )),
                    Text('LEADERBOARD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 35,
                          wordSpacing: 10,
                          color: Colors.white,
                        )),
                  ],
                )),
              ),
              SizedBox(
                child: Stack(children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 36.0),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 80,
                          height: SizeConfig.blockSizeVertical * 55,
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
                          child: ListView(
                            padding:
                                EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            children: displayedUserList,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Center(
                      child: Container(
                        width: 290,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentScoreType = 'Easy';
                                  displayedUserList =
                                      buildUserList(currentTopN);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFFBEF3)),
                                foregroundColor: MaterialStateProperty.all(
                                    Color(0xff6C007D)),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    side: BorderSide.none,
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0.0),
                              ),
                              child: Text(
                                'Easy',
                                style: TextStyle(
                                  fontFamily: 'Catfiles',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentScoreType = 'Medium';
                                  displayedUserList =
                                      buildUserList(currentTopN);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFFBEF3)),
                                foregroundColor: MaterialStateProperty.all(
                                    Color(0xff6C007D)),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    side: BorderSide.none,
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0.0),
                              ),
                              child: Text(
                                'Medium',
                                style: TextStyle(
                                    fontFamily: 'Catfiles',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentScoreType = 'Hard';
                                  displayedUserList =
                                      buildUserList(currentTopN);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xffFFBEF3)),
                                foregroundColor: MaterialStateProperty.all(
                                    Color(0xff6C007D)),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    side: BorderSide.none,
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0.0),
                              ),
                              child: Text(
                                'Hard',
                                style: TextStyle(
                                    fontFamily: 'Catfiles',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          displayedUserList = buildUserList(0);
                          currentTopN = 0; //display all users
                        });
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff9C51E8)),
                      ),
                      child: Text(
                        '    ALL    ',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          displayedUserList =
                              buildUserList(10); //display top 10 scores
                          currentTopN = 10;
                        });
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff9C51E8)),
                      ),
                      child: Text(
                        '  TOP 10  ',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          displayedUserList =
                              buildUserList(5); //display top 5 scores
                          currentTopN = 5;
                        });
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff9C51E8)),
                      ),
                      child: Text(
                        '  TOP 5  ',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
