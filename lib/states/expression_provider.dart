import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
/* import 'package:mongo_dart/mongo_dart.dart';
 */
import 'package:zodiac_star/data/dream.dart';
import 'package:zodiac_star/data/mini_items.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';

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

  Future<void> getDreamTitles(String letter) async {
    filteredTitles!.clear();
    allTitles!.clear();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isList = false;
      notifyListeners();
    });

    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FirebaseConstant.dreamTitles)
          .where('letter', isEqualTo: letter)
          .get();

      for (var doc in result.docs) {
        List<dynamic> itemTitles = doc['title'];
        for (var title in itemTitles) {
          allTitles!.add(title.toString());
          filteredTitles!.add(title.toString());
        }
      }
    } catch (e) {
      print("Error fetching dream titles: $e");
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
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FirebaseConstant.dreamContent)
          .where('title', isEqualTo: title)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        throw Exception("Dream with title $title not found");
      }

      var dreamData = result.docs.first.data() as Map<String, dynamic>;
      return Dream.fromJson(dreamData);
    } catch (e) {
      print("Error fetching dream by title: $e");
      rethrow;
    }
  }
}
