import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restaurantcity3/data/model/restaurant_detail.dart';
import 'package:restaurantcity3/data/model/restaurant_search.dart';
import '../model/restaurants.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<Restaurants> getListRestaurant(http.Client client) async {
    final response = await client.get(Uri.parse("${_baseUrl}list"));
    try {
      if (response.statusCode == 200) {
        return Restaurants.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get restaurant list');
      }
    } on SocketException {
      throw 'No Internet Connection';
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(id, http.Client client) async {
    final response =
    await client.get(Uri.parse("${_baseUrl}detail/$id"));
    try {
      if (response.statusCode == 200) {
        return RestaurantDetail.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get detail restaurant');
      }
    } on SocketException {
      throw 'No Internet Connection';
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantSearch> getSearchRestaurants(String query, http.Client client) async {
    final response = await http.get(Uri.parse('${_baseUrl}search?q=$query'));
    if(response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant search');
    }
  }
}