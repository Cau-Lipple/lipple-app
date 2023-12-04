import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider with ChangeNotifier {
  List<int> _bookmarks = [];

  List<int> get bookmarks => _bookmarks;

  BookmarkProvider(List<int> bookmarks) {
    _bookmarks = bookmarks;
  }

  Future<void> addBookmark(int id) async {
    if (!_bookmarks.contains(id)) {
      _bookmarks.add(id);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dbList = _bookmarks.map((i) => i.toString()).toList();
    await prefs.setStringList('bookmarks', dbList);
    print('add bookmarks');
    print(_bookmarks);
    print(dbList);
    notifyListeners();
  }

  Future<void> removeBookmark(int id) async {
    if (_bookmarks.contains(id)) {
      _bookmarks.remove(id);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dbList = _bookmarks.map((i) => i.toString()).toList();
    await prefs.setStringList('bookmarks', dbList);
    print('remove bookmarks');
    print(_bookmarks);
    print(dbList);
    notifyListeners();
  }
}
