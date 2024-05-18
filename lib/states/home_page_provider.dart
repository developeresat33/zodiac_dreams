import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  PageController? pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  onItemTapped(int index) {
    pageController!.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
    currentIndex = index;
    notifyListeners();
  }
}
