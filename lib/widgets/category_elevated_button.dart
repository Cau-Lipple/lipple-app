import 'package:flutter/material.dart';
import 'package:lipple/interfaces/category_interface.dart';

Widget CategoryElevatedButton(Category category, Function()? onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 75,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: MaterialStateColor.resolveWith(
                (states) => Colors.white),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x3A1FC368), width: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shadowColor: const Color(0x3A1FC368),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              category.image,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          )
        ],
      ),
    ),
  );
}