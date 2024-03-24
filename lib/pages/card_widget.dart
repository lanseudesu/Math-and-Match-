import 'dart:math';
import 'package:appdev/models/audio.dart';
import 'package:appdev/models/card.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardWidget extends StatefulWidget {
  final Cards card;
  final Function(Cards)? onTap;

  const CardWidget({
    required this.card,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/card_icon.svg',
      width: 40,
      height: 40,
    );
  }
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  bool _disposed = false;

  void _listenerFunction() {
    setState(() {});
  }

  void _statusListenerFunction(AnimationStatus status) {
    _status = status;
    if (_status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: 800), () {
        if (!_disposed && _status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _controller.addListener(_listenerFunction);
    _controller.addStatusListener(_statusListenerFunction);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!_isAnimating) {
            if (_status == AnimationStatus.completed) {
              // Reverse animation if it's already completed
              _controller.reverse();
            } else {
              // Start animation if it's not already playing
              _controller.forward();
              FlameAudio.play('flip.mp3', volume: AudioUtil.soundVolume * 13);
            }
            if (widget.onTap != null && mounted) {
              widget.onTap!(widget.card);
            }
          } else {
            // Reverse animation immediately if another card is tapped
            _controller.reverse();
            if (widget.onTap != null && mounted) {
              widget.onTap!(widget.card);
            }
          }
        },
        child: Container(
          height: 100,
          width: 100,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              print('Animation value: ${_animation.value}');
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_animation.value * pi),
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    _animation.value <= 0.5 ? Color(0xffA673DE) : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: _animation.value <= 0.5
                    ? CustomIcon()
                    : Image.asset(
                        widget.card.imagePaths,
                        width: 50,
                        height: 50,
                      ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.removeListener(_listenerFunction);
    _controller.removeStatusListener(_statusListenerFunction);
    _controller.dispose();
    super.dispose();
  }
}
