import 'package:flutter/material.dart';

SnackBar SnackBarOk(int score) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 10),
    margin: const EdgeInsets.symmetric(vertical: 160.0, horizontal: 25),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    shape: RoundedRectangleBorder(
      side: const BorderSide(
        color: Color(0xFFFFB3B5),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: const Color(0xFFFFDCD9),
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFFFF427E),
                borderRadius: BorderRadius.circular(15)),
            child: const Icon(
              Icons.sentiment_neutral_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Text(
          "$score점, 조금 더 연습이 필요해요.",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
