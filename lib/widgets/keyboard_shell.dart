import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'typewriter_key.dart';

const Color brassAccent = Color(0xFFC8A468);

class KeyboardShell extends StatelessWidget {
  final void Function(String) onCharTyped;
  final VoidCallback onBackspacePressed;
  final VoidCallback onShiftPressed;
  final VoidCallback onNumericPressed;
  final VoidCallback onSendPressed;
  final bool isShiftEnabled;
  final bool isNumericMode;

  const KeyboardShell({
    super.key,
    required this.onCharTyped,
    required this.onBackspacePressed,
    required this.onShiftPressed,
    required this.onNumericPressed,
    required this.onSendPressed,
    required this.isShiftEnabled,
    required this.isNumericMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .5,
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 12.0),
      color: Colors.transparent,
      child: isNumericMode
          ? _buildNumericLayout(context)
          : _buildAlphabeticalLayout(context),
    );
  }

  //ABC
  Widget _buildAlphabeticalLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keyWidth = screenWidth / 12;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: "QWERTYUIOP".split('').map((char) {
                final charToShow = isShiftEnabled
                    ? char.toUpperCase()
                    : char.toLowerCase();
                return TypewriterKey(
                  label: charToShow,
                  width: keyWidth,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onCharTyped(charToShow);
                  },
                );
              }).toList(),
            ),

            Row(
              children: [
                const Spacer(flex: 1),
                ..."ASDFGHJKL".split('').map((char) {
                  final charToShow = isShiftEnabled
                      ? char.toUpperCase()
                      : char.toLowerCase();
                  return TypewriterKey(
                    label: charToShow,
                    width: keyWidth,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onCharTyped(charToShow);
                    },
                  );
                }),
                const Spacer(flex: 1),
              ],
            ),

            Row(
              children: [
                const Spacer(flex: 1),
                TypewriterKey(
                  label: 'shift',
                  width: keyWidth * 1.5,
                  heightFactor: .7,
                  shape: KeyShape.rectangle,
                  onTap: onShiftPressed,
                  isActive: isShiftEnabled,
                  child: const Icon(
                    Icons.arrow_upward,
                    color: brassAccent,
                    size: 24,
                  ),
                ),
                ..."ZXCVBNM".split('').map((char) {
                  final charToShow = isShiftEnabled
                      ? char.toUpperCase()
                      : char.toLowerCase();
                  return TypewriterKey(
                    label: charToShow,
                    width: keyWidth,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onCharTyped(charToShow);
                    },
                  );
                }),
                TypewriterKey(
                  label: 'backspace',
                  width: keyWidth * 1.5,
                  heightFactor: .7,
                  shape: KeyShape.rectangle,
                  onTap: () {
                    onBackspacePressed();
                    HapticFeedback.lightImpact();
                  },
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: brassAccent,
                    size: 20,
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),

            Row(
              children: [
                const Spacer(flex: 2),
                TypewriterKey(
                  label: "123",
                  width: keyWidth * 1.5,
                  shape: KeyShape.rectangle,
                  heightFactor: .8,
                  onTap: () {
                    onNumericPressed();
                    HapticFeedback.lightImpact();
                  },
                ),
                TypewriterKey(
                  label: ",",
                  width: keyWidth,
                  onTap: () => onCharTyped(","),
                ),
                TypewriterKey(
                  label: "SPACE",
                  width: keyWidth * 4,
                  shape: KeyShape.rectangle,
                  heightFactor: .3,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onCharTyped(" ");
                  },
                ),
                TypewriterKey(
                  label: ".",
                  width: keyWidth,
                  onTap: () => onCharTyped("."),
                ),
                TypewriterKey(
                  label: "send",
                  width: keyWidth * 1.7,
                  shape: KeyShape.rectangle,
                  heightFactor: .8,
                  onTap: () {
                    onSendPressed();
                    HapticFeedback.lightImpact();
                  },
                ),
                const Spacer(flex: 1),
              ],
            ),
          ],
        ),
      ],
    );
  }

  //123
  Widget _buildNumericLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keyWidth = screenWidth / 12;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: "1234567890"
                  .split('')
                  .map(
                    (char) => TypewriterKey(
                      label: char,
                      width: keyWidth,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onCharTyped(char);
                      },
                    ),
                  )
                  .toList(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: "@#\$%&_+-="
                  .split('')
                  .map(
                    (char) => TypewriterKey(
                      label: char,
                      width: keyWidth,
                      onTap: () {
                        onCharTyped(char);
                        HapticFeedback.lightImpact();
                      },
                    ),
                  )
                  .toList(),
            ),

            Row(
              children: [
                const Spacer(flex: 1),
                TypewriterKey(
                  label: "*/\"':;!",
                  width: keyWidth * 1.5,
                  heightFactor: .7,
                  shape: KeyShape.rectangle,
                  onTap: () {},
                  child: Center(
                    child: Text(
                      "*/..",
                      style: TextStyle(color: brassAccent, fontSize: 16),
                    ),
                  ),
                ),
                ..."?!.,'"
                    .split('')
                    .map(
                      (char) => TypewriterKey(
                        label: char,
                        width: keyWidth,
                        onTap: () {
                          onCharTyped(char);
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ),
                const SizedBox(width: 4),
                TypewriterKey(
                  label: 'backspace',
                  width: keyWidth * 1.5,
                  heightFactor: .7,
                  shape: KeyShape.rectangle,
                  onTap: () {
                    onBackspacePressed();
                    HapticFeedback.lightImpact();
                  },
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: brassAccent,
                    size: 20,
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),

            Row(
              children: [
                const Spacer(flex: 2),
                TypewriterKey(
                  label: "ABC",
                  width: keyWidth * 1.5,
                  shape: KeyShape.rectangle,
                  heightFactor: .8,
                  onTap: () {
                    onNumericPressed();
                    HapticFeedback.lightImpact();
                  },
                ),
                TypewriterKey(
                  label: ",",
                  width: keyWidth,
                  onTap: () => onCharTyped(","),
                ),
                TypewriterKey(
                  label: "SPACE",
                  width: keyWidth * 4,
                  shape: KeyShape.rectangle,
                  heightFactor: .3,
                  onTap: () {
                    onCharTyped(" ");
                    HapticFeedback.lightImpact();
                  },
                ),
                TypewriterKey(
                  label: ".",
                  width: keyWidth,
                  onTap: () => onCharTyped("."),
                ),
                TypewriterKey(
                  label: "send",
                  width: keyWidth * 1.7,
                  shape: KeyShape.rectangle,
                  heightFactor: .8,
                  onTap: () {
                    onSendPressed();
                    HapticFeedback.lightImpact();
                  },
                ),
                const Spacer(flex: 1),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
