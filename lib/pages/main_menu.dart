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
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<UserState>(builder: (context, userState, _) {
      String? loggedInUser = userState.loggedInUser;
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/icons/bg_menu.png"),
                fit: BoxFit.cover)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Center(
              child: _menuButtons(),
            ),
          ),
          if (loggedInUser != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Logged in as: $loggedInUser',
                style: TextStyle(fontSize: 18),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showSignUpDialog(context);
                },
                child: Text('Sign Up'),
              ),
              if (loggedInUser != null)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<UserState>(context, listen: false)
                          .setLoggedInUser(null); // Log out the current user
                    });
                  },
                  child: Text('Log Out'),
                ),
              ElevatedButton(
                onPressed: () {
                  _showLoginDialog(context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ]),
      );
    }));
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
        return AlertDialog(
          title: Text('Sign Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final existingUser = prefs.getString(usernameController.text);
                if (existingUser != null) {
                  // already exists
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(
                          'Username already exists. Please choose a different one.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // new acc
                  await prefs.setString(
                      usernameController.text, passwordController.text);
                  Provider.of<UserState>(context, listen: false)
                      .setLoggedInUser(usernameController.text);
                  Navigator.pop(context); // Close dialog
                }
              },
              child: Text('Create Account'),
            ),
          ],
        );
      },
    );
  }

  // Method to show login dialog
  Future<void> _showLoginDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final savedPassword = prefs.getString(usernameController.text);
                if (savedPassword == null) {
                  // Account does not exist
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Username does not exist.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else if (savedPassword == passwordController.text) {
                  // Successful login
                  Provider.of<UserState>(context, listen: false)
                      .setLoggedInUser(usernameController.text);
                  Navigator.pop(context); // Close dialog
                } else {
                  // Invalid password
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid password.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Log In'),
            ),
          ],
        );
      },
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
                      fontFamily: 'Aero',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(-2, -2),
                          color: Color(0xffFF00FF),
                          blurRadius: 0,
                        ),
                        Shadow(
                          offset: Offset(2, 2),
                          color: Color(0xff00FFFF),
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
                    // Show dialog to prompt user to log in
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Please Log In'),
                          content: Text('You need to log in first to play.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    _showDifficultyDialog(context);
                  }

                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => const Game()));
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
                      fontSize: 25,
                      fontFamily: 'Aero',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(-1.5, -1.5),
                          color: Color(0xffFF00FF),
                          blurRadius: 0,
                        ),
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          color: Color(0xff00FFFF),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {}),
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
                              builder: (context) => const Leaderboard()));
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
                    onPressed: () {},
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
                    onPressed: () {},
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
}
