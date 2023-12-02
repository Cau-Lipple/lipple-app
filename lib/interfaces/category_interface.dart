import 'package:flutter/material.dart';

class Category {
  const Category(this.title, this.image);

  final String title;
  final Image image;

  factory Category.fromJson(String title) {
    return Category(title, Image.asset('assets/images/work.png'));
  }
}
