import 'package:restaurantcity3/data/model/restaurant_detail.dart';

class Restaurants {
  Restaurants({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<RestaurantsElement> restaurants;

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
    error: json["error"],
    message: json["message"],
    count: json["count"],
    restaurants: List<RestaurantsElement>.from(
        json["restaurants"].map((x) => RestaurantsElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

class RestaurantsElement {
  RestaurantsElement({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final Menus menus;

  factory RestaurantsElement.fromJson(Map<String, dynamic> json) =>
      RestaurantsElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
        menus: json['menus'] != null
            ? Menus.fromJson(json["menus"])
            : Menus(foods: [], drinks: []),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };
}