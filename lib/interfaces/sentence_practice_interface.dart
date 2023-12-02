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
}
