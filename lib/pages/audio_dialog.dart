import 'package:appdev/models/audio.dart';
import 'package:flutter/material.dart'; // Import AudioUtil to access volume settings
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_svg/svg.dart'; // Import FlameAudio for audio control

class VolumeSettingsDialog extends StatefulWidget {
  @override
  _VolumeSettingsDialogState createState() => _VolumeSettingsDialogState();
}

class _VolumeSettingsDialogState extends State<VolumeSettingsDialog> {
  double _soundVolume = AudioUtil.soundVolume;
  double _bgVolume = AudioUtil.bgVolume;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 500,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _audioSettings(context),
            Positioned(
              top: 95,
              left: 55,
              right: 55,
              child: Stack(children: [
                Text('SETTINGS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Catfiles',
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
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
                      fontSize: 40,
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
      width: 500,
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
          width: 8, // Border width
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align children at their start positions
            children: [
              Container(
                // Adjust alignment and padding here
                width: 40, // Adjust width as needed
                height: 40, // Adjust height as needed
                child: SizedBox(
                  width: 40, // Match the width of the container
                  height: 40, // Match the height of the container
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xffFFBEF3), // Shape of the container (circle)
                      border: Border.all(
                        color: Color(0xffFFBEF3), // Border color
                        width: 3, // Border width
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.all(5), // Padding inside the container
                      child: SvgPicture.asset(
                          _soundVolume == 0
                              ? 'assets/icons/sfx_muted.svg' // Path when sound is muted
                              : 'assets/icons/sfx_volume.svg', // Default path // Replace with your SVG file path
                          width: 28, // Adjust width as needed
                          height: 28,
                          color: Color.fromARGB(
                              255, 129, 65, 192) // Adjust height as needed
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16), // Add spacing between the icon and the text
              Column(
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
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      thumbColor: Color(0xffA673DE), // Customize thumb shape
                      overlayColor: Color(0xffA673DE).withOpacity(
                        0.3,
                      ), // Color of the overlay when thumb is pressed
                      activeTrackColor:
                          Color(0xffA673DE), // Increase the track height
                      trackShape: CustomTrackShape(), // Use custom track shape
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
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align children at their start positions
            children: [
              Container(
                // Adjust alignment and padding here
                width: 40, // Adjust width as needed
                height: 40, // Adjust height as needed
                child: SizedBox(
                  width: 40, // Match the width of the container
                  height: 40, // Match the height of the container
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xffFFBEF3), // Shape of the container (circle)
                      border: Border.all(
                        color: Color(0xffFFBEF3), // Border color
                        width: 3, // Border width
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.all(5), // Padding inside the container
                      child: SvgPicture.asset(
                          _bgVolume == 0
                              ? 'assets/icons/bg_muted.svg' // Path when sound is muted
                              : 'assets/icons/bg_volume.svg', // Replace with your SVG file path
                          width: 28, // Adjust width as needed
                          height: 28,
                          color: Color.fromARGB(
                              255, 129, 65, 192) // Adjust height as needed
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16), // Add spacing between the icon and the text
              Column(
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
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      thumbColor: Color(0xffA673DE), // Customize thumb shape
                      overlayColor: Color(0xffA673DE).withOpacity(
                        0.3,
                      ), // Color of the overlay when thumb is pressed
                      activeTrackColor:
                          Color(0xffA673DE), // Increase the track height
                      trackShape: CustomTrackShape(), // Use custom track shape
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
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xff9C51E8)), // Background color
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Text color
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12), // Button padding
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Button border radius
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
                  onPressed: () {
                    // Save volume settings
                    AudioUtil.soundVolume = _soundVolume;
                    AudioUtil.bgVolume = _bgVolume;

                    // Restart background music with the updated volume
                    FlameAudio.bgm.stop();
                    FlameAudio.bgm.play('menu.mp3', volume: _bgVolume);

                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Color(0xffA673DE))), // Border color
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12), // Button padding
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Button border radius
                      ),
                    ),
                  ),
                  child: Text('      SAVE      ',
                      style: TextStyle(
                          fontFamily: 'Catfiles',
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA673DE),
                          fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
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
