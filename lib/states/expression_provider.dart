import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zodiac_star/data/dream.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';

class ExpressionProvider extends ChangeNotifier {
  int currentIndex = 0;
  Dream? dreamData;
  List<String>? titles;
  bool? isList = false;


  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<List<String>> getDreamTitles(String letter) async {
    List<String> titles = [];
    var result = await MongoDatabase.dreamTitlesCollection
        .find(where.eq('letter', letter))
        .toList();

    for (var item in result) {
      List<dynamic> itemTitles = item['titles'];
      for (var title in itemTitles) {
        titles.add(title.toString());
      }
    }

    return titles;
  }

  Future<Dream> getDreamByTitle(String title) async {
    var result = await MongoDatabase.dreamCollection
        .findOne(where.eq('dream_title', title));
    return Dream.fromJson(result);
  }


}
