import 'dart:convert';
import 'package:lipple/interfaces/category_interface.dart';

class Result {
  const Result(
      {required this.totalScore,
      required this.videoScore,
      required this.soundScore,
      required this.isFace});

  final int totalScore;
  final List<int> videoScore;
  final List<int> soundScore;
  final bool isFace;

  factory Result.fromJson(Map<String, dynamic> json, Category category) {
    if (json.containsKey('mp4') &&
        json.containsKey('sound') &&
        json.containsKey('tot') &&
        json.containsKey('isFace')) {
      return Result(
        totalScore: int.parse(json['tot']),
        videoScore: json['mp4'],
        soundScore: json['sound'],
        isFace: json['isFace'],
      );
    } else {
      throw const FormatException('Failed to create result.');
    }
  }

  factory Result.tmpJson(Map<String, dynamic> json) {
    if (json.containsKey('mp4') &&
        json.containsKey('sound') &&
        json.containsKey('tot') &&
        json.containsKey('isFace')) {
      return Result(
        totalScore: json['tot'],
        videoScore: json['mp4'].cast<int>(),
        soundScore: json['sound'].cast<int>(),
        isFace: json['isFace'] > 0 ? true : false,
      );
    } else {
      throw const FormatException('Failed to create result.');
    }
  }
}
