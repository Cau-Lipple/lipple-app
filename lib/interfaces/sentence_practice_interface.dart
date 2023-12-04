import 'dart:convert';

import 'package:lipple/interfaces/category_interface.dart';

class SentencePractice {
  const SentencePractice({required this.id, required this.name, this.category});

  final int id;
  final String name;
  final Category? category;

  factory SentencePractice.fromJson(
      Map<String, dynamic> json, Category category) {
    if (json.containsKey('File_Id') && json.containsKey('name')) {
      return SentencePractice(
        id: int.parse(json['File_Id']),
        name: json['name'] as String,
        category: category,
      );
    } else {
      throw const FormatException('Failed to create sentence.');
    }
  }

  factory SentencePractice.fromJsonAll(
      Map<String, dynamic> json, Category category) {
    if (json.containsKey('File_Id') && json.containsKey('name')) {
      String fileId = json['File_Id'];
      String name = json['name'];
      return SentencePractice(
        id: int.parse(fileId),
        name: utf8.decode(name.codeUnits),
        category: category,
      );
    } else {
      throw const FormatException('Failed to create sentence.');
    }
  }

  factory SentencePractice.tmpJson(
      Map<String, dynamic> json, Category category) {
    if (json.containsKey('File_Id') && json.containsKey('name')) {
      return SentencePractice(
        id: json['File_Id'],
        name: utf8.decode(json['name']),
        category: category,
      );
    } else {
      throw const FormatException('Failed to create sentence.');
    }
  }
}
