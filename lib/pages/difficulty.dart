import 'package:appdev/pages/game.dart';
import 'package:appdev/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultyPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(children: [
        _cardDialog(context),
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
                    backgroundColor: const Color(0xffFFBEF3),
                    side: const BorderSide(color: Colors.transparent)),
                child: SvgPicture.asset('assets/icons/cross.svg',
                    color: Colors.white)))
      ]),
    );
  }

  Container _cardDialog(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff9C51E8), // Shadow color
            spreadRadius: 0, // Spread radius
            blurRadius: 0, // Blur radius
            offset: Offset(8, 8), // Custom offset (horizontal, vertical)
          ),
        ],
        border: Border.all(
          color: Color(0xffFFBEF3).withOpacity(1), // Border color
          width: 8, // Border width
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            Text('CHOOSE\nDIFFICULTY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
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
            Text('CHOOSE\nDIFFICULTY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.white,
                )),
          ]),
          const SizedBox(height: 7),
          Text(
            'Make sure you have read the "how to play" section.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xffFF52A4),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DifficultyInfoPopup(
                        difficulty: 'Easy', imagePath: 'assets/icons/easy.png');
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFBEF3),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: Text(
                'EASY',
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DifficultyInfoPopup(
                        difficulty: 'Medium',
                        imagePath: 'assets/icons/medium.png');
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffA673DE),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: Text(
                'MEDIUM',
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DifficultyInfoPopup(
                        difficulty: 'Hard', imagePath: 'assets/icons/hard.png');
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF52A4),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: Text(
                'HARD',
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class DifficultyInfoPopup extends StatelessWidget {
  final String difficulty;
  final String imagePath;

  const DifficultyInfoPopup({
    required this.difficulty,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(children: [
        _difficultyDialog(context),
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
                    backgroundColor: Color(0xffFF52A4),
                    side: const BorderSide(color: Colors.transparent)),
                child: SvgPicture.asset('assets/icons/cross.svg',
                    color: Colors.white)))
      ]),
    );
  }

  Container _difficultyDialog(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffFFBEF3),
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
          color: Color(0xffFF52A4).withOpacity(1),
          width: 8, // Border width
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 7),
          Stack(children: [
            Text(difficulty,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.fontSize * 3,
                  shadows: [
                    Shadow(
                      offset: Offset(5.5, 5.5),
                      color: Color.fromARGB(255, 194, 144, 248),
                      blurRadius: 0,
                    ),
                  ],
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 7
                    ..color = Color(0xffFF52A4),
                )),
            Text(difficulty,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Catfiles',
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.fontSize * 3,
                  color: Color(0xffFFBEF3),
                )),
          ]),
          const SizedBox(height: 15),
          Text(
            _getDifficultyInfo(difficulty),
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Game(difficulty: difficulty)));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF52A4),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3),
            child: Text(
              'Continue',
              style: TextStyle(
                fontFamily: 'Catfiles',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyInfo(String difficulty) {
    // Add logic to return the information based on the selected difficulty
    switch (difficulty) {
      case 'Easy':
        return 'Simple addition and subtraction equations.\n4x4 grid totaling 16 cards\n5 Minutes timer';
      case 'Medium':
        return 'Added multiplication, division, and multiple operations. \n5x4 grid totaling 20 cards\n4 minutes timer';
      case 'Hard':
        return 'Equations include exponentiation and square roots.\n6x5 grid totaling 30 cards\n3 minutes timer';
      default:
        return '';
    }
  }
}
