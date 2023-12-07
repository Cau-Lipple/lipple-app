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
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: SizedBox(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '전체 카테고리',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  return const Center(child: CircularProgressIndicator());
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
                          () => context.push(detailsPath, extra: category),
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
