import 'package:flutter/material.dart';
import 'package:lipple/interfaces/category_interface.dart';

Widget SquareCategoryButton(Category category, Function()? onPressed) {
  return SizedBox(
    height: 170,
    width: 150,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x3A1FC368), width: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(0),
        shadowColor: const Color(0x4A1FC368),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 110,
                child: Text(
                  category.title,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    overflow: TextOverflow.clip
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: category.image,
            ),
          )
        ],
      ),
    ),
  );
}
