import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:lipple/widgets/my_elevated_button.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  static List<SentencePractice> allSentences = <SentencePractice>[
    const SentencePractice(id: 0, name: '오늘도 좋은 하루 보내길 바라!'),
    const SentencePractice(id: 1, name: '집에 가다가 너무 귀여운 검은 고양이를 만났어.'),
    const SentencePractice(id: 2, name: '내일까지 제출해야 할 과제가 있어서 안 돼.'),
    const SentencePractice(id: 3, name: '오늘 내가 제일 좋아하는 메뉴가 나온다!'),
  ];

  final String practicePath = '/bookmark/practice';

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
                children: allSentences.map((SentencePractice sentencePractice) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFC1C9BF)),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        sentencePractice.name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                        color: Colors.grey,
                      ),
                      onTap: () => context.go(practicePath),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
