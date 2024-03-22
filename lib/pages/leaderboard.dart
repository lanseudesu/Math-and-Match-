import 'package:appdev/pages/main_menu.dart';
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
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Set _isMounted to true when the widget is mounted
    Player.fetchData().then((data) {
      if (_isMounted) {
        setState(() {
          users = data;
        });
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false; // Set _isMounted to false when the widget is disposed
    super.dispose();
  }

  List<Player> getUniqueUsersWithHighestScores() {
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

  List<Widget> buildUserList() {
    List<Player> uniqueUsers = getUniqueUsersWithHighestScores();

    uniqueUsers.sort((a, b) {
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

    return uniqueUsers
        .asMap()
        .map((index, user) {
          late Widget
              leadingWidget; // Declare leadingWidget as a late variable to delay its initialization
          late Color backgroundColor;
          late double tileHeight;
          late double fontSize;

          switch (index) {
            case 0:
              leadingWidget = Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 180, 18)
                      .withOpacity(0.8), // Yellow circle for the first item
                ),
                alignment: Alignment.center,
                child: Text('${index + 1}',
                    style: TextStyle(
                        fontFamily: 'Archivo Black',
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 119, 56, 4),
                        fontSize: 18)),
              );
              backgroundColor = Color.fromARGB(255, 255, 238, 160)
                  .withOpacity(0.8); // Yellow background for the first item
              tileHeight = 60;
              fontSize = 18;
              break;
            case 1:
              leadingWidget = Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(
                      255, 226, 226, 226), // Grey circle for the second item
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontFamily: 'Archivo Black',
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 65, 65, 65),
                      fontSize:
                          16), // Adjust font size and color for the number
                ),
              );
              backgroundColor = Color.fromARGB(
                  255, 197, 197, 197); // Grey background for the second item
              tileHeight = 55;
              fontSize = 16;
              break;
            case 2:
              leadingWidget = Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(
                      255, 153, 91, 69), // Brown circle for the third item
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontFamily: 'Archivo Black',
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 183, 154),
                      fontSize:
                          16), // Adjust font size and color for the number
                ),
              );
              backgroundColor = Color.fromARGB(
                  255, 214, 142, 115); // Brown background for the third item
              tileHeight = 55;
              fontSize = 16;
              break;
            default:
              leadingWidget = Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(
                      255, 199, 155, 243), // Brown circle for the third item
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontFamily: 'Archivo Black',
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 82, 33, 131),
                      fontSize:
                          16), // Adjust font size and color for the number
                ),
              );
              backgroundColor =
                  Color.fromARGB(255, 146, 81, 199).withOpacity(0.3);
              tileHeight = 50;
              fontSize = 14; // Transparent background for the rest of the items
          }

          return MapEntry(
            index,
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: 4.0), // Add vertical spacing
              decoration: BoxDecoration(
                color:
                    backgroundColor, // Apply background color to the entire ListTile
                borderRadius:
                    BorderRadius.circular(10.0), // Circular border radius
              ),
              child: Container(
                height: tileHeight,
                child: ListTile(
                  leading: Container(
                    child: leadingWidget,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${user.username}',
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w800, fontSize: fontSize),
                      ),
                      Text(
                        '${_getScore(user)}',
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w900, fontSize: fontSize),
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

  String _getScore(Player user) {
    switch (currentScoreType) {
      case 'Easy':
        return '${user.easyScore}';
      case 'Medium':
        return '${user.mediumScore}';
      case 'Hard':
        return '${user.hardScore}';
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
              SizedBox(
                child: Transform.scale(
                  scale: 0.70, // Adjust the scale factor as needed
                  child: Image.asset(
                    'assets/icons/leaderboard_title.png',
                  ),
                ),
              ),
              Stack(children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 36.0), // Adjust top padding as needed
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: 330,
                        height: 520,
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
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          children: buildUserList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Container(
                      width: 320,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentScoreType = 'Easy';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffFFBEF3)),
                              foregroundColor:
                                  MaterialStateProperty.all(Color(0xff6C007D)),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(15), // Adjust as needed
                                    topRight:
                                        Radius.circular(15), // Adjust as needed
                                  ),
                                  side: BorderSide.none, // No border
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0.0),
                            ),
                            child: Text(
                              'Easy',
                              style: TextStyle(
                                  fontFamily: 'Aero',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentScoreType = 'Medium';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffFFBEF3)),
                              foregroundColor:
                                  MaterialStateProperty.all(Color(0xff6C007D)),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(15), // Adjust as needed
                                    topRight:
                                        Radius.circular(15), // Adjust as needed
                                  ),
                                  side: BorderSide.none, // No border
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0.0),
                            ),
                            child: Text(
                              'Medium',
                              style: TextStyle(
                                  fontFamily: 'Aero',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentScoreType = 'Hard';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffFFBEF3)),
                              foregroundColor:
                                  MaterialStateProperty.all(Color(0xff6C007D)),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(15), // Adjust as needed
                                    topRight:
                                        Radius.circular(15), // Adjust as needed
                                  ),
                                  side: BorderSide.none, // No border
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0.0),
                            ),
                            child: Text(
                              'Hard',
                              style: TextStyle(
                                  fontFamily: 'Aero',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
