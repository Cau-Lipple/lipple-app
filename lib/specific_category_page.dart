import 'package:flutter/material.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:lipple/widgets/my_elevated_button.dart';

class SpecificCategoryPage extends StatefulWidget {
  const SpecificCategoryPage({required this.category, super.key});

  final Category category;

  @override
  State<SpecificCategoryPage> createState() => _SpecificCategoryPageState();
}

class _SpecificCategoryPageState extends State<SpecificCategoryPage> {
  static List<SentencePractice> allSentences = <SentencePractice>[
    const SentencePractice(id: '0', title: '어제 힘들게 작성한 보고서를 컴퓨터 오류로 날렸어.'),
    const SentencePractice(id: '1', title: '이건 문장 테스트 리스트에 들어갈 문장이야.'),
    const SentencePractice(id: '2', title: '오늘도 야근해야할 것 같아.'),
  ];

  @override
  Widget build(BuildContext context) {
    final args = widget.category;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //색변경
        ),
        title: const Text(
          '문장 연습',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
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
              child: SizedBox(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      args.title,
                      style: const TextStyle(
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
                        sentencePractice.title,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                        color: Colors.grey,
                      ),
                      onTap: () {},
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
