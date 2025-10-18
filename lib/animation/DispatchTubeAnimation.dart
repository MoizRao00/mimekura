import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:mimekura/widgets/BrassBaseWidget.dart';



const Color brassAccent = Color(0xFFC8A468);
const Color darkBrassBorder = Color(0xFF8C6D3F);
const Color agedBrass = Color(0xFFB28A50);
const Color glassTint = Color(0x33E0CFA8);
const Color vintageShadow = Color(0xFF2B1A10);
const Color paperBrassBorder = Color(0xFFBCA57A);

class DispatchTubeAnimation extends StatefulWidget {
  final AnimationController controller;

  final Offset buttonPosition;
  final Size buttonSize;
  const DispatchTubeAnimation({
    super.key,
    required this.controller,
    required this.buttonPosition,
    required this.buttonSize,
  });

  @override
  State<DispatchTubeAnimation> createState() => _DispatchTubeAnimationState();
}

class _DispatchTubeAnimationState extends State<DispatchTubeAnimation> {
  final AudioPlayer _player = AudioPlayer();

  bool _playedTopSound = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse || status == AnimationStatus.dismissed) {
        _playedTopSound = false;
      }
    });

    capsuleEnter.addListener(() {
      if (capsuleEnter.value > .5 && !_playedTopSound) {
        _playedTopSound = true;
        _player.play(AssetSource('audio/1017.MP3'));
      }
    });
  }


  Animation<double> get tubeOpacity => CurvedAnimation(
    parent: widget.controller,

    curve: const Interval(0.0, 0.05, curve: Curves.easeInOut),
  );

  Animation<double> get capsuleEnter => CurvedAnimation(
    parent: widget.controller,

    curve: const Interval(0.1, 0.4, curve: Curves.easeInOut),
  );

  Animation<double> get capsuleMoveUp => CurvedAnimation(
    parent: widget.controller,

    curve: const Interval(0.4, 0.85, curve: Curves.easeIn),
  );

  Animation<double> get fadeOut => CurvedAnimation(
    parent: widget.controller,

    curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
  );


  Widget _buildGlassTube(double tubeHeight) {
    final Color warmHighlight = const Color(0xFFFFF8E1).withOpacity(0.30);
    final Color warmShadow = const Color(0xFF5D4037).withOpacity(0.30);
    final ribGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        warmShadow,
        warmHighlight,
        warmShadow,
        warmHighlight,
        warmShadow,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    return Container(
      width: 45,
      height: tubeHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF874d00).withOpacity(0.3),
        border: Border.all(color: paperBrassBorder, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(decoration: BoxDecoration(gradient: ribGradient)),
      ),
    );
  }

  Widget _buildCapsule(double tubeWidth, double tubeHeight) {
    final double capsuleWidth = tubeWidth * 0.70;

    final double capsuleHeight = 80.0;
    final double startOffset = -80;
    final double position =
        startOffset + // start fully below the tube
            (capsuleEnter.value * 120) + // entry upward distance
            (capsuleMoveUp.value * (tubeHeight - capsuleHeight ));


    return Positioned(
      bottom: position,

      child: Opacity(
        opacity: capsuleEnter.value > 0.05 ? 1.0 - fadeOut.value : 0.0,
        child: Container(
          width: capsuleWidth,
          height: capsuleHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(capsuleWidth / 2),
            border: Border.all(
              color: const Color(0xFFBFA56A).withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(capsuleWidth / 2),
                  gradient: RadialGradient(
                    colors: [
                      Colors.amberAccent.withOpacity(0.60),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                    center: Alignment.center,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: capsuleWidth + 6,
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B4E2B), Color(0xFFC8A468)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      color: const Color(0xFF3E2B18).withOpacity(0.5),
                      width: 1.5,
                    ),

                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,

                child: Container(
                  width: capsuleWidth + 6,

                  height: 12,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC8A468), Color(0xFF6B4E2B)],

                      begin: Alignment.topCenter,

                      end: Alignment.bottomCenter,
                    ),

                    border: Border.all(
                      color: const Color(0xFF3E2B18).withOpacity(0.5),
                      width: 1.5,
                    ),

                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double tubeHeight = screenHeight * .6;
    final double baseHeight = 100;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: tubeOpacity,
          child: SizedBox(
            width: 200,
            height: tubeHeight + baseHeight + 100,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    bottom : baseHeight + 40,
                child: _buildGlassTube(tubeHeight)),
                _buildCapsule(45, tubeHeight),
                Positioned(bottom: 0, child: const BrassBaseWidget()),
              ],
            ),
          ),
        );
      },
    );
  }
}
