import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


const Color brassAccent = Color(0xFFC8A468);
const Color darkBrassBorder = Color(0xFF8C6D3F);
const Color agedBrass = Color(0xFFB28A50);
const Color glassTint = Color(0x33E0CFA8);
const Color vintageShadow = Color(0xFF2B1A10);

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
  bool _playedSound = false;
  bool _playedTopSound = false;


  @override
  void initState() {
    super.initState();

    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse ||
          status == AnimationStatus.dismissed) {
        _playedSound = false;
        _playedTopSound = false;
      }
    });


    ringOpen.addListener(() {
      if (ringOpen.value > 0.98 && !_playedSound) {
        _playedSound = true;
        _player.play(AssetSource('audio/shunk.mp3'));
      }
    });

    capsuleMoveUp.addListener(() {
      if (capsuleMoveUp.value > 0.8 && !_playedTopSound) {
        _playedTopSound = true;
        _player.play(AssetSource('audio/shunk.mp3'));
      }
    });
  }


  Animation<double> get tubeOpacity => CurvedAnimation(
    parent: widget.controller,
    curve: const Interval(0.0, 0.01, curve: Curves.easeInOut),
  );

  Animation<double> get ringOpen => CurvedAnimation(
    parent: widget.controller,
    curve: const Interval(0.0, 0.2, curve: Curves.easeOutBack),
  );

  Animation<double> get capsuleEnter => CurvedAnimation(
    parent: widget.controller,
    curve: const Interval(0.20, 0.50, curve: Curves.easeInOut),

  );
  Animation<double> get ringClose => CurvedAnimation(
    parent: widget.controller,
    curve: const Interval(0.5, 0.6, curve: Curves.easeInCubic),
  );

  Animation<double> get capsuleMoveUp => CurvedAnimation(
    parent: widget.controller,
    curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
  );

  Animation<double> get fadeOut => CurvedAnimation(
    parent: widget.controller,
    curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
  );

  Widget _buildRing({required bool isTop, required double openValue}) {
    return Align(
      alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: Transform(
        alignment: isTop ? Alignment.bottomCenter : Alignment.topCenter, // hinge
        transform: Matrix4.identity()
          ..rotateX(isTop ? -openValue * 0.8 : openValue * 1.2) // bigger tilt
          ..translate(0.0, isTop ? -openValue * 5 : openValue * 12), // move down
        child: Container(
          width: 50,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                agedBrass.withOpacity(isTop ? 0.85 : 0.9),
                brassAccent.withOpacity(0.9),
                darkBrassBorder.withOpacity(0.8),
              ],
              begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
              end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
            ),
            border: Border.all(color: darkBrassBorder, width: 2.2),
            borderRadius: BorderRadius.vertical(
              top: isTop ? const Radius.circular(40) : Radius.zero,
              bottom: !isTop ? const Radius.circular(40) : Radius.zero,
            ),
            boxShadow: [
              BoxShadow(
                color: vintageShadow.withOpacity(0.6),
                blurRadius: 6,
                offset: Offset(0, isTop ? -2 : 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTube(double tubeHeight) {
    return Container(
      width: 50,
      height: tubeHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            glassTint.withValues(alpha: 0.45),
            Colors.transparent,
            glassTint.withValues(alpha: 0.4),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: agedBrass.withValues(alpha: 0.7), width: 2),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildCapsule(double tubeWidth, double tubeHeight) {
    final double capsuleWidth = tubeWidth * 0.70;
    final double capsuleHeight = 80.0;

    // Blend both travel motions
    final double combinedTravel =
        capsuleEnter.value * 0.5 + capsuleMoveUp.value * 0.5;
    final double position = combinedTravel * tubeHeight - 60;

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
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(capsuleWidth / 2),
            border: Border.all(
              color: const Color(0xFFBFA56A).withOpacity(0.6),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // 💡 Inner soft glow layer
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(capsuleWidth / 2),
                  gradient: RadialGradient(
                    colors: [
                      Colors.amberAccent.withOpacity(0.50),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                    center: Alignment.center,
                  ),
                ),
              ),

              // 🔩 Capsule caps
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
                    border: Border.all(color: Color(0xFF3E2B18), width: 1.5),
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50)),
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
                    border: Border.all(color: Color(0xFF3E2B18), width: 1.5),
                    borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(50)),
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

    final double tubeHeight = screenHeight * .35;

    return Positioned(
      bottom: screenHeight * .44,
      left: screenWidth * .75,
      child: AnimatedBuilder(

        animation: widget.controller,
        builder: (context, child) {
          final double openValue =
              ringOpen.value - ringClose.value.clamp(0.0, 1.0);
          return SizedBox(
            width: 100,
            height: tubeHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildGlassTube(tubeHeight),
                _buildCapsule(50, tubeHeight),
                _buildRing(isTop: true, openValue: 0),
                _buildRing(isTop: false, openValue: openValue),
              ],
            ),
          );
        },
      ),
    );
  }
}
