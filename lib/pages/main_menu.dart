import 'package:appdev/models/audio.dart';
import 'package:appdev/models/players.dart';
import 'package:appdev/pages/audio_dialog.dart';
import 'package:appdev/utils/size_config.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdev/pages/difficulty.dart';
import 'package:appdev/pages/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:appdev/main.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late SharedPreferences prefs;
  final BoxDecoration dialogBoxDecoration = BoxDecoration(
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
  );

  @override
  void initState() {
    super.initState();

    initializeSharedPreferences();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('menu.mp3', volume: AudioUtil.bgVolume);
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child:
          Scaffold(body: Consumer<UserState>(builder: (context, userState, _) {
        String? loggedInUser = userState.loggedInUser;
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/icons/bg_menu.png"),
                  fit: BoxFit.cover)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _menuButtons(),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showSignUpDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Color(0xffFF52A4)),
                  child: Container(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Catfiles',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(-1.5, -1.5),
                            color: Color(0xff9c51e8),
                            blurRadius: 0,
                          ),
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            color: Color(0xffFFBEF3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showLoginDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Color(0xffFF52A4)),
                  child: Container(
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Catfiles',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(-1.5, -1.5),
                            color: Color(0xff9c51e8),
                            blurRadius: 0,
                          ),
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            color: Color(0xffFFBEF3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            if (loggedInUser != null)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Provider.of<UserState>(context, listen: false)
                        .setLoggedInUser(null); //log out current user
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xffFF52A4),
                  fixedSize: Size(197, 40),
                  padding: EdgeInsets.all(2),
                ),
                child: Text(
                  'Logged in as: "$loggedInUser" | click to Log Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Catfiles',
                    fontSize: 7,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
          ]),
        );
      })),
    );
  }

  void updateLoggedInUser(String username) {
    Provider.of<UserState>(context, listen: false).setLoggedInUser(username);
  }

  // Method to show sign-up dialog
  Future<void> _showSignUpDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double dialogWidth =
            MediaQuery.of(context).size.width * 0.8; // Adjust as needed

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.all(10),
            decoration: dialogBoxDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 2),
                Stack(
                  children: [
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Catfiles',
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
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
                          ..color = Color(0xffFF52A4),
                      ),
                    ),
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Catfiles',
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontFamily: 'Catfiles',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff9c51e8).withOpacity(0.7),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xff9c51e8),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontFamily: 'Catfiles',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff9c51e8).withOpacity(0.7),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xff9c51e8),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
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
                      child: Text(
                        '   CANCEL   ',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () async {
                        final existingUser =
                            prefs.getString(usernameController.text);
                        if (existingUser != null) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                margin: const EdgeInsets.all(10),
                                decoration: dialogBoxDecoration,
                                child: buildErrorDialog(
                                  context,
                                  'Username already exists! Please choose a different one.',
                                ),
                              ),
                            ),
                          );
                        } else {
                          await prefs.setString(
                              usernameController.text, passwordController.text);
                          Player.addUserData(usernameController.text, 0, 0, 0);
                          Provider.of<UserState>(context, listen: false)
                              .setLoggedInUser(usernameController.text);
                          Navigator.pop(context); // Close dialog
                        }
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: Color(0xffA673DE),
                          ),
                        ),
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
                      child: Text(
                        'sign Up',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA673DE),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            backgroundColor: Colors.transparent,
            child: Container(
                width: 400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.all(10),
                decoration: dialogBoxDecoration,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Stack(children: [
                    Text('Log-In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
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
                            ..color = Color(0xffFF52A4),
                        )),
                    Text('Log-In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white,
                        )),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            fontFamily: 'Catfiles',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9c51e8).withOpacity(0.7)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xff9c51e8), // Change the border color
                            width: 2.0, // Change the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            fontFamily: 'Catfiles',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9c51e8).withOpacity(0.7)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xff9c51e8), // Change the border color
                            width: 2.0, // Change the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff9C51E8)), // Background color
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // Text color
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12), // Button padding
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Button border radius
                              ),
                            ),
                          ),
                          child: Text('   CANCEL   ',
                              style: TextStyle(
                                  fontFamily: 'Catfiles',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ),
                        SizedBox(width: 20),
                        OutlinedButton(
                          onPressed: () async {
                            final savedPassword =
                                prefs.getString(usernameController.text);
                            if (savedPassword == null) {
                              // Account does not exist
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      margin: const EdgeInsets.all(10),
                                      decoration: dialogBoxDecoration,
                                      child: buildErrorDialog(
                                          context, 'Username does not exist!'),
                                    )),
                              );
                            } else if (savedPassword ==
                                passwordController.text) {
                              // Successful login
                              Provider.of<UserState>(context, listen: false)
                                  .setLoggedInUser(usernameController.text);
                              Navigator.pop(context); // Close dialog
                            } else {
                              // Invalid password
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      margin: const EdgeInsets.all(10),
                                      decoration: dialogBoxDecoration,
                                      child: buildErrorDialog(
                                          context, 'Invalid Password!'),
                                    )),
                              );
                            }
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                    color: Color(0xffA673DE))), // Border color
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12), // Button padding
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Button border radius
                              ),
                            ),
                          ),
                          child: Text('  Log in  ',
                              style: TextStyle(
                                  fontFamily: 'Catfiles',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffA673DE),
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ])));
      },
    );
  }

  Container _okay(BuildContext context) {
    return Container(
      width: 100,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xffFF52A4)), // Background color
          foregroundColor:
              MaterialStateProperty.all<Color>(Colors.white), // Text color
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                horizontal: 15, vertical: 12), // Button padding
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Button border radius
            ),
          ),
        ),
        child: Text('  OKAY  ',
            style: TextStyle(
                fontFamily: 'Catfiles',
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 15)),
      ),
    );
  }

  Future<void> _showDifficultyDialog(BuildContext context) async {
    final String? difficulty = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return DifficultyPopup();
      },
    );

    if (difficulty != null) {
      print('Selected Difficulty: $difficulty');
    }
  }

  Column _menuButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(children: [
          Container(
            width: 300,
            height: 200,
            child: Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
          ),
          SizedBox(
            width: 200,
            height: 80,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Color(0xffFF52A4)),
                child: Container(
                  child: const Text(
                    "PLAY",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Catfiles',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(-2, -2),
                          color: Color(0xff9c51e8),
                          blurRadius: 0,
                        ),
                        Shadow(
                          offset: Offset(2, 2),
                          color: Color(0xffFFBEF3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  if (Provider.of<UserState>(context, listen: false)
                          .loggedInUser ==
                      null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              margin: const EdgeInsets.all(10),
                              decoration: dialogBoxDecoration,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 7),
                                    Stack(children: [
                                      Text('Please  Login',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Catfiles',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(5, 5.5),
                                                color: Color.fromARGB(
                                                    255, 194, 144, 248),
                                                blurRadius: 0,
                                              ),
                                            ],
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 7
                                              ..color = Color(0xffFF52A4),
                                          )),
                                      Text('Please  Login',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Catfiles',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25,
                                            color: Colors.white,
                                          )),
                                    ]),
                                    const SizedBox(height: 8),
                                    Text(
                                      'You need to log in first to play.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffFF52A4)),
                                    ),
                                    const SizedBox(height: 15),
                                    _okay(context),
                                  ]),
                            ));
                      },
                    );
                  } else {
                    _showDifficultyDialog(context);
                  }
                }),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Color(0xffFF52A4)),
                child: Container(
                  child: const Text(
                    "How to Play",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Catfiles',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(-1.5, -1.5),
                          color: Color(0xff9c51e8),
                          blurRadius: 0,
                        ),
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          color: Color(0xffFFBEF3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  showHowToPlayDialog(context);
                }),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffFF52A4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    alignment: Alignment.center,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Leaderboard()));
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/leaderboard.svg',
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffFF52A4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return VolumeSettingsDialog();
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffFF52A4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      bool backButtonHandled = await _onBackPressed();
                      if (!backButtonHandled) {
                        return;
                      } else {
                        SystemNavigator.pop();
                      }
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/exit.svg',
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ],
    );
  }

  void showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              _howToPlay(context),
              Positioned(
                top: 1,
                left: 1,
                height: 33,
                width: 33,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: const CircleBorder(),
                    backgroundColor: Color(0xffFFBEF3),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/cross.svg',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _howToPlay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.all(10),
      decoration: dialogBoxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 7),
          Stack(children: [
            Text('HOW TO PLAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
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
                    ..color = Color(0xffFF52A4),
                )),
            Text('HOW TO PLAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Colors.white,
                )),
          ]),
          const SizedBox(height: 17),
          Text(
            'Match pairs of cards with equations sharing the same answer. Tap two cards to reveal their equations. If they match, they are removed. if not, they flip back. Keep matching until all pairs are found.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xffFF52A4)),
          ),
          const SizedBox(height: 10),
          Image.asset('assets/icons/htpexample.png', width: 180),
          const SizedBox(height: 10),
          Text(
            'Complete the game quickly before time runs out. Compete and aim for the leaderboard with your fastest times. Good luck and enjoy!',
            textAlign: TextAlign.justify,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xffFF52A4)),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              width: 150,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xffFF52A4)),
                    elevation: MaterialStateProperty.all<double>(5.0)),
                child: Text(
                  'Understood!',
                  style: TextStyle(
                    fontFamily: 'Catfiles',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildErrorDialog(BuildContext context, String errorMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 7),
        Stack(
          children: [
            Text(
              'Error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Catfiles',
                fontWeight: FontWeight.w500,
                fontSize: 25,
                shadows: [
                  Shadow(
                    offset: Offset(5, 5.5),
                    color: Color.fromARGB(255, 194, 144, 248),
                    blurRadius: 0,
                  ),
                ],
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 7
                  ..color = Color(0xffFF52A4),
              ),
            ),
            Text(
              'Error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Catfiles',
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xffFF52A4),
          ),
        ),
        const SizedBox(height: 15),
        _okay(context),
      ],
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                    width: SizeConfig.safeBlockHorizontal * 80,
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
                        Text('Quit Game?',
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
                        Text('Quit Game?',
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
                        'Don\'t\' you love us anymore? </3',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Catfiles',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9C51E8)),
                      ),
                      SizedBox(height: 10),
                      Center(
                          child: LayoutBuilder(builder: (context, constraints) {
                        double fontSize = constraints.maxWidth *
                            0.05; // Adjust the multiplier as needed
                        double buttonWidth = constraints.maxWidth * 0.3;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(color: Color(0xffA673DE))),
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                        horizontal: buttonWidth *
                                            0.1, // Adjust padding based on button size
                                        vertical: buttonWidth * 0.08),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ), //yes, continue
                                child: Text("    QUIT T-T    ",
                                    style: TextStyle(
                                        fontFamily: 'Catfiles',
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xffA673DE),
                                        fontSize: fontSize)),
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              flex: 1,
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
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
                                        horizontal: buttonWidth *
                                            0.1, // Adjust padding based on button size
                                        vertical: buttonWidth * 0.08),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                child: Text("      STAY :D     ",
                                    style: TextStyle(
                                        fontFamily: 'Catfiles',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: fontSize)),
                              ),
                            )
                          ],
                        );
                      }))
                    ])));
          },
        ) ??
        false;
  }
}
