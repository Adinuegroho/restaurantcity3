import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/data/model/restaurant_detail.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService restaurantApi;

  DetailRestaurantProvider({required this.restaurantApi, required String id}) {
    _fetchDetailRestaurant(id);
  }

  late RestaurantDetail _detailRestaurant;
  late StatusState _state;
  String _message = '';

  RestaurantDetail get detail => _detailRestaurant;
  StatusState get state => _state;
  String get message => _message;

  Future _fetchDetailRestaurant(id) async {
    try {
      _state = StatusState.loading;
      notifyListeners();
      final resto = await restaurantApi.getDetailRestaurant(id, http.Client());
      if (resto.restaurant.toJson().isEmpty) {
        _state = StatusState.noData;
        notifyListeners();
        return _message = 'Data is Empty';
      } else {
        _state = StatusState.hasData;
        notifyListeners();
        return _detailRestaurant = resto;
      }
    } catch (e) {
      _state = StatusState.error;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}
