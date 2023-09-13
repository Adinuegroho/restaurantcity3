import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/data/model/restaurant_search.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService restaurantApi;
  String query;

  SearchProvider({required this.restaurantApi, this.query = ''}) {
    _fetchSearchRestaurant(query);
  }

  late RestaurantSearch _searchRestaurant;
  late StatusState _state;
  String _message = '';

  RestaurantSearch get search => _searchRestaurant;
  StatusState get state => _state;
  String get message => _message;

  searchRestaurant(String newValue) {
    query = newValue;
    _fetchSearchRestaurant(query);
    notifyListeners();
  }

  Future _fetchSearchRestaurant(value) async {
    try {
      _state = StatusState.loading;
      notifyListeners();
      final restaurant = await restaurantApi.getSearchRestaurants(query, http.Client());
      if (restaurant.restaurants.isEmpty) {
        _state = StatusState.noData;
        notifyListeners();
        return _message = 'data is empty';
      } else {
        _state = StatusState.hasData;
        notifyListeners();
        return _searchRestaurant = restaurant;
      }
    } catch (e) {
      _state = StatusState.error;
      notifyListeners();
      return _message = 'Error => $e';
    }
  }
}