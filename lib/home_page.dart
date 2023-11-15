import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:lipple/widgets/my_elevated_button.dart';
import 'package:lipple/widgets/square_category_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Category> allCategories = <Category>[
    Category('일, 직장, 직업', Image.asset('assets/images/work.png')),
    Category('휴가', Image.asset('assets/images/vacation.png')),
    Category('교통수단', Image.asset('assets/images/transport.png')),
    Category('반려동물', Image.asset('assets/images/pet.png')),
    Category('문화, 예술', Image.asset('assets/images/art.png')),
  ];

  final String categoryDetailsPath = '/category/specific';

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
                    children: [
                      SizedBox(
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '안녕하세요!',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              '오늘은 어떤 문장을\n배워볼까요?',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: 170,
                                height: 35,
                                child: MyElevatedButton('오늘 목표 확인하기', () {}),
                              ),
                            )
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
                          '이 문장은 예시로 사용된 문장입니다.',
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
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 8.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '오늘은 어떤 주제를 해볼까요?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '전체보기 >',
                        style: TextStyle(
                          color: Color(0xFF959595),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: allCategories.map((Category category) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SquareCategoryButton(
                            category,
                            () => context.go(
                                  categoryDetailsPath,
                                  extra: category,
                                )),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
