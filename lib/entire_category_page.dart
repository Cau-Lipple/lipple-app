import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/widgets/category_elevated_button.dart';
import 'package:lipple/widgets/my_elevated_button.dart';
import 'package:lipple/interfaces/category_interface.dart';
import 'package:http/http.dart' as http;

class EntireCategoryPage extends StatefulWidget {
  const EntireCategoryPage({super.key});

  @override
  State<EntireCategoryPage> createState() => _EntireCategoryPageState();
}

class _EntireCategoryPageState extends State<EntireCategoryPage> {
  final String detailsPath = '/category/specific';
  late Future<List<Category>> allCategories;

  // static List<Category> allCategories = <Category>[
  //   Category('일, 직장, 직업', Image.asset('assets/images/work.png')),
  //   Category('휴가', Image.asset('assets/images/vacation.png')),
  //   Category('교통수단', Image.asset('assets/images/transport.png')),
  //   Category('반려동물', Image.asset('assets/images/pet.png')),
  //   Category('문화, 예술', Image.asset('assets/images/art.png')),
  // ];

  Future<List<Category>> fetchCategory() async {
    var url = 'http://10.19.247.96:3000';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(response.body)['body'] as Map<String, dynamic>;
      List<dynamic> dynamicList = body['categories'];
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
  }

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
            child: FutureBuilder<List<Category>>(
              future: allCategories,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Category>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Category> categories = snapshot.data ?? [];
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: categories.map((Category category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CategoryElevatedButton(
                          category,
                          () => context.go(detailsPath, extra: category),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
