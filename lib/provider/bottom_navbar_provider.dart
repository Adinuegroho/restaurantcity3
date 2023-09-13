import 'package:flutter/material.dart';
import 'package:restaurantcity3/ui/favorite_list.dart';
import 'package:restaurantcity3/ui/profil_list.dart';
import 'package:restaurantcity3/ui/restaurant_list.dart';

class BottomNavBar extends ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> listWidget = [
    const RestaurantList(),
    const FavoriteList(),
    const ProfilList(),
  ];

  currentPage(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
