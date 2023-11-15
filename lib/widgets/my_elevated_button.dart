import 'package:flutter/material.dart';

Widget MyElevatedButton(String title, Function()? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 18),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF008040),
            fontSize: 13,
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x269BF599),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xFF008040),
            size: 15,
          ),
        )
      ],
    ),
  );
}