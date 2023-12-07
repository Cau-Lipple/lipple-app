import 'package:flutter/material.dart';

SnackBar SnackBarGood(double score) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 5),
    margin: const EdgeInsets.symmetric(vertical: 160.0, horizontal: 25),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    shape: RoundedRectangleBorder(
      side: const BorderSide(
        color: Color(0xFFFBEB6A),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: const Color(0xFFFEFACD),
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFFF2D309),
                borderRadius: BorderRadius.circular(15)),
            child: const Icon(
              Icons.sentiment_satisfied_alt_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Text(
          "${score.toStringAsFixed(2)}점, 거의 다 왔어요!",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
