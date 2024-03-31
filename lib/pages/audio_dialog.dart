import 'package:appdev/models/audio.dart';
import 'package:appdev/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_svg/svg.dart';

//audio settings in main menu

class VolumeSettingsDialog extends StatefulWidget {
  @override
  _VolumeSettingsDialogState createState() => _VolumeSettingsDialogState();
}

class _VolumeSettingsDialogState extends State<VolumeSettingsDialog> {
  double _soundVolume = AudioUtil.soundVolume;
  double _bgVolume = AudioUtil.bgVolume;
  double fontSize = SizeConfig.fontSize;

  @override
  Widget build(BuildContext context) {
    double dialogWidth = SizeConfig.screenWidth * 0.8;
    double dialogHeight = SizeConfig.screenHeight * 0.6;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: SizeConfig.screenWidth * 0.8,
        height: SizeConfig.screenHeight * 0.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _audioSettings(context),
            Positioned(
              top: dialogHeight / 2 - (dialogHeight * 0.30) - 20,
              left: (dialogWidth / 2) - (dialogWidth * 0.33) - 8,
              child: Stack(children: [
                Text('SETTINGS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Catfiles',
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                      shadows: [
                        Shadow(
                          offset: Offset(5.5, 5.5),
                          color: Color(0xffFFBEF3),
                          blurRadius: 0,
                        ),
                      ],
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 7
                        ..color = Color(0xffA673DE),
                    )),
                Text('SETTINGS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Catfiles',
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                      color: Colors.white,
                    )),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Container _audioSettings(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFFBEF3),
                      border: Border.all(
                        color: Color(0xffFFBEF3),
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SvgPicture.asset(
                          _soundVolume == 0
                              ? 'assets/icons/sfx_muted.svg' //img when sfx is muted
                              : 'assets/icons/sfx_volume.svg', //default img for sfx
                          width: 28,
                          height: 28,
                          color: Color.fromARGB(255, 129, 65, 192)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Text(
                        'SFX VOLUME',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          color: Color(0xffA673DE),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 5,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8),
                        thumbColor: Color(0xffA673DE),
                        overlayColor: Color(0xffA673DE).withOpacity(
                          0.3,
                        ),
                        activeTrackColor: Color(0xffA673DE),
                        trackShape: CustomTrackShape(),
                      ),
                      child: Slider(
                        value: _soundVolume,
                        onChanged: (newValue) {
                          setState(() {
                            _soundVolume = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFFBEF3),
                      border: Border.all(
                        color: Color(0xffFFBEF3),
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SvgPicture.asset(
                          _bgVolume == 0
                              ? 'assets/icons/bg_muted.svg' //bg muted image
                              : 'assets/icons/bg_volume.svg', //default bg music image
                          width: 28,
                          height: 28,
                          color: Color.fromARGB(255, 129, 65, 192)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Text(
                        'MUSIC VOLUME',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          color: Color(0xffA673DE),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 5,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8),
                        thumbColor: Color(0xffA673DE),
                        overlayColor: Color(0xffA673DE).withOpacity(
                          0.3,
                        ),
                        activeTrackColor: Color(0xffA673DE),
                        trackShape: CustomTrackShape(),
                      ),
                      child: Slider(
                        value: _bgVolume,
                        onChanged: (newValue) {
                          setState(() {
                            _bgVolume = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(child: LayoutBuilder(
            builder: (context, constraints) {
              double fontSize = constraints.maxWidth * 0.05;
              double buttonWidth = constraints.maxWidth * 0.3;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff9C51E8)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: buttonWidth * 0.1,
                              vertical: buttonWidth * 0.08),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text(
                        '     CANCEL     ',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        //save volume settings
                        AudioUtil.soundVolume = _soundVolume;
                        AudioUtil.bgVolume = _bgVolume;

                        //restart background music with the updated volume
                        FlameAudio.bgm.stop();
                        FlameAudio.bgm.play('menu.mp3', volume: _bgVolume);

                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Color(0xffA673DE))),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: buttonWidth * 0.1,
                              vertical: buttonWidth * 0.08),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text(
                        '        SAVE        ',
                        style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA673DE),
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  //for volume slider custom shape
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + 8;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
