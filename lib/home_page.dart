import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:lipple/providers/bookmark_provider.dart';
import 'package:lipple/widgets/my_elevated_button.dart';
import 'package:lipple/widgets/square_category_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String categoryDetailsPath = '/category/specific';
  final String allPracticePath = '/category/specific/practice';
  final String bookmarkPracticePath = '/bookmark/practice';
  late Future<List<Category>> allCategories;
  late List<SentencePractice> allSentences;
  late SentencePractice randomAllSentences;
  late SentencePractice randomBookmarkSentences;
  bool initialized = false;

  // static List<SentencePractice> allSentences = <SentencePractice>[
  //   SentencePractice(
  //     id: 0,
  //     name: '이건 즐겨찾기 리스트에 들어갈 목적으로 작성된 문장이야.',
  //     category: Category('일, 직장, 직업', Image.asset('assets/images/work.png')),
  //   ),
  //   SentencePractice(
  //       id: 1,
  //       name: '여기에 카테고리를 적어두면 좀 좋을 것 같은데.',
  //       category: Category('일, 직장, 직업', Image.asset('assets/images/work.png'))),
  //   SentencePractice(
  //       id: 2,
  //       name: '메인에서도 필요하고... 근데 아직 설계 확정 안됨.',
  //       category: Category('일, 직장, 직업', Image.asset('assets/images/work.png'))),
  // ];
  // static List<Category> allCategories = <Category>[
  //   Category('일, 직장, \n직업', Image.asset('assets/images/work.png')),
  //   Category('휴가', Image.asset('assets/images/vacation.png')),
  //   Category('교통수단', Image.asset('assets/images/transport.png')),
  //   Category('반려동물', Image.asset('assets/images/pet.png')),
  //   Category('문화, 예술', Image.asset('assets/images/art.png')),
  // ];

  Future<void> initializeSentence(int randBookmarkSentenceId) async {
    allSentences = await fetchSentence();
    int randNum = Random().nextInt(allSentences.length);
    randomAllSentences = allSentences[randNum];
    randomBookmarkSentences = allSentences
        .firstWhere((element) => element.id == randBookmarkSentenceId);

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

  Future<List<Category>> fetchCategory() async {
    var url =
        'https://9c83ph95ma.execute-api.ap-northeast-2.amazonaws.com/beta/category';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> dynamicList =
          json.decode(response.body)['body'] as List<dynamic>;
      List<Category> categories =
          dynamicList.map((item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Cannot get categories');
    }
  }

  @override
  void initState() {
    super.initState();
    allCategories = fetchCategory();
    int randNum =
        Random().nextInt(context.read<BookmarkProvider>().bookmarks.length);
    int sentenceId = context.read<BookmarkProvider>().bookmarks[randNum];
    initializeSentence(sentenceId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        runSpacing: 20,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                height: 380,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF22BB66),
                      Color(0xFF22BB66),
                      Colors.transparent,
                      Colors.transparent
                    ],
                    stops: [0.0, 0.72, 0.72, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25.0, top: 75.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요!',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '오늘은 어떤 문장을\n배워볼까요?',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset('assets/images/main.png')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF008040),
                      width: 0.7,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          '오늘의 문장',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          '오늘도 좋은 하루 보내길 바라!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                color: Color(0xFF007239),
                                offset: Offset(0, -7),
                              )
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF6AD399),
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 170,
                          height: 35,
                          child: MyElevatedButton(
                            '지금 바로 공부하기',
                            () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '오늘은 어떤 주제를 해볼까요?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: TextButton(
                          onPressed: () => context.go('/category'),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            '전체보기 >',
                            style: TextStyle(
                              color: Color(0xFF959595),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<Category>>(
                  future: allCategories,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Category>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Category> categories = snapshot.data ?? [];
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((Category category) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SquareCategoryButton(
                                category,
                                () => context.go(categoryDetailsPath,
                                    extra: category),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 8.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '랜덤으로 학습해요!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1FC368),
                              surfaceTintColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color(0x3A1FC368), width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              shadowColor: const Color(0x3A1FC368),
                              elevation: 3,
                            ),
                            onPressed: () {
                              if (initialized) {
                                context.push(allPracticePath,
                                    extra: randomAllSentences);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shuffle_rounded,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        '전체 랜덤',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              surfaceTintColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color(0x3A1FC368), width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              shadowColor: const Color(0x3A1FC368),
                              elevation: 3,
                            ),
                            onPressed: () {
                              if (initialized) {
                                context.push(bookmarkPracticePath,
                                    extra: randomBookmarkSentences);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 28,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        '즐겨찾기 랜덤',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '즐겨찾기한 문장들이에요!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: TextButton(
                          onPressed: () => context.go('/bookmark'),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            '전체보기 >',
                            style: TextStyle(
                              color: Color(0xFF959595),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: initialized
                      ? Consumer<BookmarkProvider>(
                          builder: (context, bookmarkProvider, child) {
                            return ListView.builder(
                              shrinkWrap: true,
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
                                        bottom: BorderSide(
                                            color: Color(0xFFC1C9BF)),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        sentence.category?.title ?? '',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF078043)),
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          sentence.name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 17,
                                        color: Colors.grey,
                                      ),
                                      onTap: () => context.push(
                                          bookmarkPracticePath,
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
                  // ListView(
                  //   shrinkWrap: true,
                  //   padding: EdgeInsets.zero,
                  //   children:
                  //       allSentences.map((SentencePractice sentencePractice) {
                  //     return Container(
                  //       decoration: const BoxDecoration(
                  //         border: Border(
                  //           bottom: BorderSide(color: Color(0xFFC1C9BF)),
                  //         ),
                  //       ),
                  //       child: ListTile(
                  //         title: Text(
                  //           sentencePractice.category?.title ?? '',
                  //           style: const TextStyle(
                  //               fontSize: 11, color: Color(0xFF078043)),
                  //         ),
                  //         subtitle: Padding(
                  //           padding: const EdgeInsets.only(top: 5.0),
                  //           child: Text(
                  //             sentencePractice.name,
                  //             style: const TextStyle(
                  //                 fontSize: 14, fontWeight: FontWeight.w500),
                  //             maxLines: 1,
                  //             overflow: TextOverflow.fade,
                  //             softWrap: false,
                  //           ),
                  //         ),
                  //         trailing: const Icon(
                  //           Icons.arrow_forward_ios_rounded,
                  //           size: 17,
                  //           color: Colors.grey,
                  //         ),
                  //         onTap: () {},
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
