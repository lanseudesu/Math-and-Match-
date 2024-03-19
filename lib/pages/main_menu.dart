//import 'package:appdev/pages/easy.dart';
import 'package:appdev/pages/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/icons/bg_menu.png"),
              fit: BoxFit.cover)),
      child: Center(
        child: _menuButtons(),
      ),
    ));
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
                          offset: Offset(-2, -2), // Top left shadow
                          color: Color(0xffFF00FF),
                          blurRadius: 0,
                        ),
                        Shadow(
                          offset: Offset(2, 2), // Bottom right shadow
                          color: Color(0xff00FFFF),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Game()));
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
                          offset: Offset(-1.5, -1.5), // Top left shadow
                          color: Color(0xffFF00FF),
                          blurRadius: 0,
                        ),
                        Shadow(
                          offset: Offset(1.5, 1.5), // Bottom right shadow
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
                    onPressed: () {},
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
