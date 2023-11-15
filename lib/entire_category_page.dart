import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/specific_category_page.dart';
import 'package:lipple/widgets/category_elevated_button.dart';
import 'package:lipple/widgets/my_elevated_button.dart';
import 'package:lipple/interfaces/category_interface.dart';

class EntireCategoryPage extends StatelessWidget {
  const EntireCategoryPage({super.key});

  final String detailsPath = '/category/specific';

  static List<Category> allCategories = <Category>[
    Category('일, 직장, 직업', Image.asset('assets/images/work.png')),
    Category('휴가', Image.asset('assets/images/vacation.png')),
    Category('교통수단', Image.asset('assets/images/transport.png')),
    Category('반려동물', Image.asset('assets/images/pet.png')),
    Category('문화, 예술', Image.asset('assets/images/art.png')),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: SizedBox(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '전체 카테고리',
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
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              padding: EdgeInsets.zero,
              children: allCategories.map((Category category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CategoryElevatedButton(
                    category,
                    () => context.go(detailsPath, extra: category),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
