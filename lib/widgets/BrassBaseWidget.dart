import 'package:flutter/material.dart';

class BrassBaseWidget extends StatelessWidget {
  const BrassBaseWidget({super.key});

  @override
  Widget build(BuildContext context) {

    Widget buildContentLayer({
      required double width,
      required double height,
      BorderRadiusGeometry? borderRadius,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: const DecorationImage(
            image: AssetImage("assets/images/img.png"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F3B25).withOpacity(0.8),
              blurRadius: 15,
              spreadRadius: 2,
            ),
            BoxShadow(color: Colors.black.withValues(alpha: .4),
                blurRadius: 25,
                spreadRadius: 5,
                offset:  Offset(04, 04))
          ],
        ),
        // This adds the subtle surface gradient for a 3D look
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ),
      );
    }


    return SizedBox(
      width: 120,
      height: 150,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [

          // 1st Layer
          Positioned(
            child: buildContentLayer(
              width: 60,
              height: 15,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
                bottom: Radius.circular(5),
              ),
            ),
          ),

          // 2nd Layer
          Positioned(
            top: 15,
            child: Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: .1),
                    BlendMode.darken
                  ),
                  image: AssetImage("assets/images/img.png"),
                  fit: BoxFit.fill,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F3B25).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),

                ],
             borderRadius: BorderRadius.vertical(top: Radius.circular(-5),bottom: Radius.circular(-10))
              ),
              
            ),
          ),
          Positioned(
            top: 35,
            child: buildContentLayer(
              width: 60,
              height: 15,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
                bottom: Radius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
