import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:lipple/widgets/my_elevated_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  // static List<SentencePractice> allSentences = <SentencePractice>[
  //   const SentencePractice(id: 0, name: '오늘도 좋은 하루 보내길 바라!'),
  //   const SentencePractice(id: 1, name: '집에 가다가 너무 귀여운 검은 고양이를 만났어.'),
  //   const SentencePractice(id: 2, name: '내일까지 제출해야 할 과제가 있어서 안 돼.'),
  //   const SentencePractice(id: 3, name: '오늘 내가 제일 좋아하는 메뉴가 나온다!'),
  // ];

  late Future<List<SentencePractice>> allSentences;
  final String practicePath = '/bookmark/practice';
  List<SentencePractice> bookmarkSentences = [];

  Future<void> initializeData() async {
    // 데이터를 가져오는 비동기 메서드 호출
    List<SentencePractice> fetchedSentences = await fetchSentence();

    // 가져온 문장들 중 북마크된 문장들을 필터링
    List<SentencePractice> filteredBookmarkedSentences = [];
    for (var sentence in fetchedSentences) {
      if (await isBookmark(sentence.id)) {
        filteredBookmarkedSentences.add(sentence);
      }
    }
    // 필터링된 북마크 문장들을 저장
    setState(() {
      bookmarkSentences = filteredBookmarkedSentences;
    });
    print(bookmarkSentences);
  }

  Future<List<SentencePractice>> fetchSentence() async {
    var url = 'http://192.168.35.233:3000/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(response.body)['body'] as Map<String, dynamic>;
      List<dynamic> sentenceList = body['videos'];

      List<SentencePractice> sentences = sentenceList.map((item) {
        //TODO: 서버 연결 시 tmp에서 바꿔야 함
        Category category = Category.tmpJson(item['category']);
        return SentencePractice.tmpJson(item, category);
      }).toList();
      return sentences;
    } else {
      throw Exception('Cannot get categories');
    }
  }

  Future<bool> isBookmark(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> dbList = (prefs.getStringList('bookmark') ?? []);
    List<int> originalList = dbList.map((i) => int.parse(i)).toList();
    return originalList.contains(id);
  }

  @override
  void initState() {
    super.initState();
    // 페이지가 나타날 때 초기화 작업 수행
    initializeData();
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
                          child: MyElevatedButton('랜덤 학습하기', () {}),
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
              child: ListView(
                padding: EdgeInsets.zero,
                children: bookmarkSentences.map((SentencePractice sentence) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFC1C9BF)),
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
                      onTap: () => context.go(practicePath, extra: sentence),
                    ),
                  );
                }).toList(),
              ),
              // child: FutureBuilder<List<SentencePractice>>(
              //   future: allSentences,
              //   builder: (BuildContext context,
              //       AsyncSnapshot<List<SentencePractice>> snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       List<SentencePractice> sentences = snapshot.data ?? [];
              //       return ListView(
              //         padding: EdgeInsets.zero,
              //         children: sentences.map((SentencePractice sentence) {
              //           return Container(
              //             decoration: const BoxDecoration(
              //               border: Border(
              //                 bottom: BorderSide(color: Color(0xFFC1C9BF)),
              //               ),
              //             ),
              //             child: ListTile(
              //               title: Text(
              //                 sentence.name,
              //                 maxLines: 1,
              //                 overflow: TextOverflow.fade,
              //                 softWrap: false,
              //               ),
              //               trailing: const Icon(
              //                 Icons.arrow_forward_ios_rounded,
              //                 size: 17,
              //                 color: Colors.grey,
              //               ),
              //               onTap: () =>
              //                   context.go(practicePath, extra: sentence),
              //             ),
              //           );
              //         }).toList(),
              //       );
              //     }
              //   },
              // ),
            ),
          )
        ],
      ),
    );
  }
}
