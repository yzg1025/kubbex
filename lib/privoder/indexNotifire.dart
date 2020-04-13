import 'package:flutter/material.dart';

class GuidPage with ChangeNotifier{
  //int _index = 0;
  double _page = 0;
  //int get index => _index;
  double get page => _page;

  // set index(int newIndex){
  //   _index = newIndex;
  //   notifyListeners();
  // }
  
  GuidPage(PageController pageController){
    pageController.addListener((){
      _page = pageController.page;
      notifyListeners();
    });
  }

}