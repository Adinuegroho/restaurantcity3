import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/data/model/restaurants.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var restaurantList = await ApiService().getListRestaurant(http.Client());
    var randomRestaurant = restaurantList
        .restaurants[Random().nextInt(restaurantList.restaurants.length)];

    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "New Restaurant Recommendation";

    var androidPlatformChannel = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      enableLights: true,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var platformChannel = NotificationDetails(android: androidPlatformChannel);

    var titleNotification = "<b>New Restaurant Recommendation For You</b>";
    var bodyNotification = randomRestaurant.name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      bodyNotification,
      platformChannel,
      payload: json.encode(randomRestaurant.toJson()),
    );
  }

  void configureSelectionNotificationSubject(
      BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantsElement.fromJson(json.decode(payload));

      Navigator.pushNamed(context, route, arguments: data.id);
    });
  }
}
