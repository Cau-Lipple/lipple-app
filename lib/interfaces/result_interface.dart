import 'dart:convert';
import 'package:lipple/interfaces/category_interface.dart';

class Result {
  const Result(
      {required this.totalScore,
      required this.videoScore,
      required this.soundScore,
      required this.isFace});

  final double totalScore;
  final List<double> videoScore;
  final List<double> soundScore;
  final bool isFace;

  factory Result.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('mp4_score') &&
        json.containsKey('wav_score') &&
        json.containsKey('total_score') &&
        json.containsKey('is_face')) {
      List<double> video = [];
      List<double> sound = [];
      for (var item in json['mp4_score']) {
        if (item is double) {
          video.add(item);
        } else if (item is int) {
          video.add(item.toDouble());
        } else if (item is String) {
          double parsedValue = double.tryParse(item.toString()) ?? 0.0;
          video.add(parsedValue);
        }
      }
      for (var item in json['wav_score']) {
        if (item is double) {
          sound.add(item);
        } else if (item is int) {
          sound.add(item.toDouble());
        } else if (item is String) {
          double parsedValue = double.tryParse(item.toString()) ?? 0.0;
          sound.add(parsedValue);
        }
      }
      return Result(
        totalScore: json['total_score'],
        videoScore: video,
        soundScore: sound,
        isFace: json['is_face'] > 0 ? true : false,
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
