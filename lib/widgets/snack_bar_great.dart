import 'package:flutter/material.dart';

SnackBar SnackBarGreat(int score) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 10),
    margin: const EdgeInsets.symmetric(vertical: 160.0, horizontal: 25),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    shape: RoundedRectangleBorder(
      side: const BorderSide(
        color: Color(0xFF7AB4FD),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: const Color(0xFFD2E9FE),
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFF2271F9),
                borderRadius: BorderRadius.circular(15)),
            child: const Icon(
              Icons.sentiment_very_satisfied_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Text(
          "$score점, 좋은 발음입니다!",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
