import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:lipple/providers/bookmark_provider.dart';
import 'package:lipple/widgets/my_elevated_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late List<SentencePractice> allSentences;
  final String practicePath = '/bookmark/practice';
  late SentencePractice? randomSentence;
  bool initialized = false;

  Future<void> initializeData(int randBookmarkSentenceId) async {
    allSentences = await fetchSentence();
    randomSentence = allSentences
        .firstWhereOrNull((element) => element.id == randBookmarkSentenceId);

    setState(() {
      initialized = true;
    });
  }

  Future<List<SentencePractice>> fetchSentence() async {
    var url =
        'https://9c83ph95ma.execute-api.ap-northeast-2.amazonaws.com/beta/videos';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(response.body)['body'] as Map<String, dynamic>;
      List<dynamic> sentenceList = body['videos'];

      List<SentencePractice> sentences = sentenceList.map((item) {
        Category category = Category.fromJson(item['category']);
        return SentencePractice.fromJsonAll(item, category);
      }).toList();
      return sentences;
    } else {
      throw Exception('Cannot get categories');
    }
  }

  @override
  void initState() {
    super.initState();

    int sentenceId = -1;
    if (context.read<BookmarkProvider>().bookmarks.isNotEmpty) {
      int randNum =
          Random().nextInt(context.read<BookmarkProvider>().bookmarks.length);
      sentenceId = context.read<BookmarkProvider>().bookmarks[randNum];
    }
    initializeData(sentenceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            height: 210,
            decoration: const BoxDecoration(
              color: Color(0xFF22BB66),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '즐겨찾기',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 35,
                          child: MyElevatedButton('랜덤 학습하기', () {
                            if (initialized) {
                              if (randomSentence != null &&
                                  context
                                      .read<BookmarkProvider>()
                                      .bookmarks
                                      .contains(randomSentence!.id)) {
                                context.push(practicePath,
                                    extra: randomSentence);
                              } else if (context
                                  .read<BookmarkProvider>()
                                  .bookmarks
                                  .isNotEmpty) {
                                int randNum = Random().nextInt(context
                                    .read<BookmarkProvider>()
                                    .bookmarks
                                    .length);
                                int randSentenceId = context
                                    .read<BookmarkProvider>()
                                    .bookmarks[randNum];

                                randomSentence = allSentences.firstWhereOrNull(
                                    (element) => element.id == randSentenceId);
                                setState(() {});

                                if (randomSentence != null) {
                                  context.push(practicePath,
                                      extra: randomSentence);
                                }
                              }
                            }
                          }),
                        )
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/star.png',
                    width: 90,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: initialized
                  ? Consumer<BookmarkProvider>(
                      builder: (context, bookmarkProvider, child) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: bookmarkProvider.bookmarks.length,
                          itemBuilder: (context, index) {
                            int id = bookmarkProvider.bookmarks[index];
                            var sentence = allSentences.firstWhereOrNull(
                                (element) => element.id == id);
                            if (sentence != null) {
                              return Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xFFC1C9BF)),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    sentence.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17,
                                    color: Colors.grey,
                                  ),
                                  onTap: () => context.push(practicePath,
                                      extra: sentence),
                                ),
                              );
                            }
                          },
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
