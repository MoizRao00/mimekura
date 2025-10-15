import 'package:flutter/material.dart';


const Color brassAccent = Color(0xFFC8A468);
const Color darkWoodBrown = Color(0xFF3D2B1F);
const Color darkBrassBorder = Color(0xFF8C6D3F);

enum KeyShape { circle, rectangle }

class TypewriterKey extends StatelessWidget {
  final bool isActive;
  final String label;
  final double width;
  final Widget? child;
  final KeyShape shape;
  final double? heightFactor;
  final VoidCallback? onTap;

  const TypewriterKey({
    super.key,
    this.isActive = false,
    required this.label,
    required this.width,
    this.heightFactor,
    this.child,
    this.shape = KeyShape.circle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCircle = shape == KeyShape.circle;

    final keyColor = isActive
        ? brassAccent.withOpacity(0.4)
        : Colors.black.withOpacity(0.3);
    final double defaultHeightFactor = isCircle ? 1.0 : 0.45;
    final double finalHeightFactor = heightFactor ?? defaultHeightFactor;
    final keyHeight = width * finalHeightFactor;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: width,
        height: keyHeight,
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: isCircle ? null : BorderRadius.circular(12),
                  shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                  color: keyColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),

            IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: width - 6,
                  height: keyHeight - 6,
                  decoration: BoxDecoration(
                    borderRadius: isCircle ? null : BorderRadius.circular(10),
                    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                    gradient: RadialGradient(
                      colors: const [Color(0xFF4a3a2a), Color(0xFF1a0a00)],
                      center: isCircle
                          ? const Alignment(0.0, -0.2)
                          : Alignment.center,
                      radius: isCircle ? 0.8 : 1.5,
                    ),
                  ),
                  child: Center(
                    child:
                        child ??
                        Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'SpecialElite',
                            color: brassAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
