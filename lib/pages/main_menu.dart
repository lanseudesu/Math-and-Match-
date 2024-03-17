import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5],
          colors: [
            Colors.white,
            Color(0xffA6E0FD),
          ],
        ),
      ),
      child: Center(
        child: _menuButtons(),
      ),
    ));
  }

  Column _menuButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 350, child: _gameTitle()),
        Column(children: [
          SizedBox(height: 20),
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
                onPressed: () {}),
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
                      'assets/icons/trophy-free-material-6-svgrepo-com.svg',
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

  Stack _gameTitle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 60,
          child: Text(
            'MATH',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w800,
              fontFamily: 'Archivo Black',
              letterSpacing: 2.0,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 18
                ..color = Color(0xffFF52A4),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          child: Text(
            'MATH',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w800,
              fontFamily: 'Archivo Black',
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 52,
          bottom: 12,
          child: Text(
            'and match',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w800,
              fontFamily: 'Aero',
              letterSpacing: 3.0,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 13
                ..color = Color(0xff9C51E8),
            ),
          ),
        ),
        Positioned(
          left: 52,
          bottom: 12,
          child: Text(
            'and match',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w800,
              fontFamily: 'Aero',
              color: Colors.white,
              letterSpacing: 3.0,
            ),
          ),
        ),
      ],
    );
  }
}
