import 'package:flutter/material.dart';


const Color brassAccent = Color(0xFFC8A468);
const Color darkBrassBorder = Color(0xFF8C6D3F);
const Color glassTubeColor = Color(0x33FFFFFF);

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: const Color(0xFF2e1e14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: brassAccent,
              decoration: InputDecoration(
                hintText: "Type Your Message..",
                hintStyle: TextStyle(
                  color: brassAccent.withOpacity(0.6),
                  fontFamily: "SpecialElite",
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              ),
              style: const TextStyle(
                color: parchmentBackground,
                fontFamily: "SpecialElite",
              ),
            ),
          ),
          const SizedBox(width: 8),
          // The Send Button
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
              ),
              child: const Icon(Icons.arrow_upward, color: brassAccent),
            ),
          ),
        ],
      ),
    );
  }
}

const Color parchmentBackground = Color(0xFFF5EFE1);
