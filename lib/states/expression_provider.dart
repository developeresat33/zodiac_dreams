import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zodiac_star/data/dream.dart';
import 'package:zodiac_star/data/mini_items.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';

class ExpressionProvider extends ChangeNotifier {
  int currentIndex = 0;
  Dream? dreamData;
  List<String>? titles;
  bool? isList = false;
  TextEditingController? searchCt;
  List<String>? filteredTitles = [];
  List<String>? allTitles = [];

  void changeIndex(int index) {
    currentIndex = index;
    getDreamTitles(MiniItems.alphabet[index]);
  }

  getDreamTitles(String letter) async {
    filteredTitles!.clear();
    allTitles!.clear();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isList = false;

      notifyListeners();
    });

    var result = await MongoDatabase.dreamTitlesCollection
        .find(where.eq('letter', letter))
        .toList();

    for (var item in result) {
      List<dynamic> itemTitles = item['titles'];
      for (var title in itemTitles) {
        allTitles!.add(title.toString());
        filteredTitles!.add(title.toString());
      }
    }
    isList = true;

    notifyListeners();
  }

  void filterTitles(String query) {
    if (query.isEmpty) {
      filteredTitles = List.from(allTitles!);
    } else {
      filteredTitles = allTitles!
          .where((title) => title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<Dream> getDreamByTitle(String title) async {
    var result = await MongoDatabase.dreamCollection
        .findOne(where.eq('dream_title', title));
    return Dream.fromJson(result);
  }

  Future<List<Map<String, dynamic>>> getExperts() async {
    return await MongoDatabase.expertCollection.find().toList();
  }
}
