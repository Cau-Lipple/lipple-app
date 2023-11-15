import 'package:flutter/material.dart';
import 'package:lipple/navigation_bar.dart';
import 'package:lipple/specific_category_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22BB66)),
        fontFamily: 'NotoSansKR',
        useMaterial3: true,
      ),
    );
  }
}
