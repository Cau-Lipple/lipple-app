import 'package:lipple/interfaces/category_interface.dart';

class SentencePractice {
  const SentencePractice({required this.id, required this.title, this.category});

  final String id;
  final String title;
  final Category? category;
}
