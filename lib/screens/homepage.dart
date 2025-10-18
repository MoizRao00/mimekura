import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../animation/DispatchTubeAnimation.dart';
import '../widgets/keyboard_shell.dart';


const Color parchmentBackground = Color(0xFFF5EFE1);
const Color darkWoodBrown = Color(0xFF3D2B1F);
const Color brassAccent = Color(0xFFC8A468);
const Color darkBrassBorder = Color(0xFF8C6D3F);
const Color glassTubeColor = Color(0x33FFFFFF);

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {

  final GlobalKey _sendButtonKey = GlobalKey();
  bool _isSendingMessage = false;
  final _textController = TextEditingController();
  bool _isShiftEnabled = false;
  bool _isNumericMode = false;
  bool _soundPlayed = false;

  // Animation + Sound
  late AnimationController _tubeController;
  bool _showTube = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Offset _buttonPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _tubeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _tubeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _tubeController.reset();
        if (mounted) {
          setState(() {
            _showTube = false;
            _isSendingMessage = false;
            _textController.clear();
            _soundPlayed = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tubeController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playTubeSound() async {
    await _audioPlayer.play(AssetSource('audio/1017.MP3'));

  }

  // Keyboard functions
  void _onCharTyped(String char) {
    _textController.text += char;
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    if (_isShiftEnabled) setState(() => _isShiftEnabled = false);
  }

  void _onBackspacePressed() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      _textController.text = text.substring(0, text.length - 1);
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
  }
  void _onShiftPressed() => setState(() => _isShiftEnabled = !_isShiftEnabled);
  void _onNumericPressed() => setState(() => _isNumericMode = !_isNumericMode);

  void _onSendPressed() {
    if (_textController.text.isEmpty || _isSendingMessage) return;

    final RenderBox renderBox = _sendButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _isSendingMessage = true;
      _showTube = true;
      _buttonPosition = position;
    });
    _tubeController.forward(from: 0);
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2e1e14),
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Image.asset("assets/images/background.png", fit: BoxFit.fill),
            ),

            // title
            Positioned(
              top: screenHeight * .04,
              left: screenWidth * .4,
              child: const Text(
                "Name",
                style: TextStyle(
                  color: darkWoodBrown,
                  fontSize: 40,
                  fontFamily: "SpecialElite",
                ),
              ),
            ),

            // text Field
            Positioned(
              top: screenHeight * .52,
              left: screenWidth * .04,
              right: screenWidth * .18,
              child: TextField(
                controller: _textController,
                readOnly: true,
                showCursor: true,
                cursorColor: brassAccent,
                decoration: InputDecoration(
                  hintText: "Type Your Message..",
                  hintStyle: const TextStyle(
                    color: glassTubeColor,
                    fontFamily: "SpecialElite",
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2e1e14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: darkBrassBorder, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: darkBrassBorder, width: 2),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
                style: const TextStyle(
                  color: darkBrassBorder,
                  fontFamily: "SpecialElite",
                ),
              ),
            ),

            // send buttonm

            Positioned(
              top: screenHeight * .52,
              right: screenWidth * .025,
              child: SizedBox(
                width: 52,
                height: 52,
                child: GestureDetector(
                  key: _sendButtonKey,
                  onTap: _onSendPressed,
                  child: AnimatedOpacity(
                    opacity: _isSendingMessage ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [BoxShadow(color: darkWoodBrown, blurRadius: 5)],
                        color: const Color(0xFF2e1e14),
                      ),
                      child: const Icon(Icons.arrow_upward, color: brassAccent),
                    ),
                  ),
                ),
              ),
            ),

            if (_showTube)
              Builder(
                builder: (context) {

                  final double tubeAnimationHeight = MediaQuery.of(context).size.height * .6 + 100 + 100;
                  const double tubeAnimationWidth = 200;

                  final double topOffset = _buttonPosition.dy - tubeAnimationHeight + 50;
                  final double leftOffset = _buttonPosition.dx - (tubeAnimationWidth / 2) + (52 / 2);

                  return Positioned(
                    top: topOffset,
                    left: leftOffset,
                    child: DispatchTubeAnimation(
                      controller: _tubeController,
                      buttonPosition: _buttonPosition,
                      buttonSize: const Size(52, 52),
                    ),
                  );
                },
              ),
            // keyboard

            Positioned(
              top: screenHeight * .57,
              bottom: 0,
              left: 0,
              right: 0,
              child: KeyboardShell(
                onCharTyped: _onCharTyped,
                onBackspacePressed: _onBackspacePressed,
                onShiftPressed: _onShiftPressed,
                onNumericPressed: _onNumericPressed,
                onSendPressed: _onSendPressed,
                isShiftEnabled: _isShiftEnabled,
                isNumericMode: _isNumericMode,
              ),
            ),

          ],
        ),
      ),
    );
  }
}