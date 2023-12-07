import 'dart:convert';

import 'package:flutter/material.dart';

class Category {
  const Category(this.title, this.image);

  final String title;
  final Image image;

  factory Category.fromJson(String title) {
    String realTitle = utf8.decode(title.codeUnits);
    Image realImage = Image.asset('assets/images/work.png');

    if (realTitle == "대중교통") {
      realImage = Image.asset('assets/images/transport.png');
    } else if (realTitle == "음식") {
      realImage = Image.asset('assets/images/diet.png');
    } else if (realTitle == "휴가") {
      realImage = Image.asset('assets/images/vacation.png');
    } else if (realTitle == "교통수단") {
      realImage = Image.asset('assets/images/car.png');
    } else if (realTitle == "사회") {
      realImage = Image.asset('assets/images/overpopulation.png');
    } else if (realTitle == "스포츠") {
      realImage = Image.asset('assets/images/sports.png');
    }
    return Category(
        utf8.decode(title.codeUnits), realImage);
  }

  factory Category.tmpJson(String title) {
    return Category(title, Image.asset('assets/images/work.png'));
  }
}
