import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/data/model/restaurant_detail.dart';
import 'package:restaurantcity3/data/model/restaurant_search.dart';
import 'package:restaurantcity3/data/model/restaurants.dart';

void main() {
  group(
    'Testing Restaurant API ',
    () {
      test(
        'Return a list restaurants',
        () async {
          final client = MockClient((request) async {
            final response = {
              "error": false,
              "message": "success",
              "count": 20,
              "restaurants": []
            };
            return Response(json.encode(response), 200);
          });
          expect(
            await ApiService().getListRestaurant(client),
            isA<Restaurants>(),
          );
        },
      );

      test(
        "Return a Detail restaurant",
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "message": "success",
                "restaurant": {
                  "id": "",
                  "name": "",
                  "description": "",
                  "city": "",
                  "address": "",
                  "pictureId": "",
                  "categories": [],
                  "menus": {"foods": [], "drinks": []},
                  "rating": 1.0,
                  "customerReviews": []
                }
              };
              return Response(json.encode(response), 200);
            },
          );
          expect(
            await ApiService().getDetailRestaurant('Restaurant Id', client),
            isA<RestaurantDetail>(),
          );
        },
      );

      test(
        'for Restaurant Search',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "founded": 1,
                "restaurants": []
              };
              return Response(json.encode(response), 200);
            },
          );

          expect(await ApiService().getSearchRestaurants('Restaurant Name', client),
              isA<RestaurantSearch>());
        },
      );
    },
  );
}
