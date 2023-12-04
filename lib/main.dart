import 'package:flutter/material.dart';
import 'package:lipple/navigation_bar.dart';
import 'package:lipple/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> dbList = (prefs.getStringList('bookmarks') ?? []);
  final List<int> bookmarks = dbList.map((i) => int.parse(i)).toList();

  runApp(MyApp(bookmarks: bookmarks,));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.bookmarks, super.key});
  final List<int> bookmarks;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookmarkProvider(bookmarks),
      child: MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22BB66)),
          fontFamily: 'NotoSansKR',
          useMaterial3: true,
        ),
      ),
    );
  }
}
