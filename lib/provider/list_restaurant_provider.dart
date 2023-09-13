import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/data/model/restaurants.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class ListRestaurantProvider extends ChangeNotifier {
  final ApiService restaurantApi;

  ListRestaurantProvider({required this.restaurantApi}) {
    _fetchRestaurantList();
  }

  late Restaurants _listRestaurant;
  late StatusState _state;
  String _message = '';

  Restaurants get list => _listRestaurant;
  StatusState get state => _state;
  String get message => _message;

  Future _fetchRestaurantList() async {
    try {
      _state = StatusState.loading;
      notifyListeners();
      final restaurant = await restaurantApi.getListRestaurant(http.Client());
      if (restaurant.restaurants.isEmpty) {
        _state = StatusState.noData;
        notifyListeners();
        return _message = 'data is empty';
      } else {
        _state = StatusState.hasData;
        notifyListeners();
        return _listRestaurant = restaurant;
      }
    } catch (e) {
      _state = StatusState.error;
      notifyListeners();
      return _message = 'Error => $e';
    }
  }
}
