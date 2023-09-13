import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/data/db/database_helper.dart';
import 'package:restaurantcity3/provider/bottom_navbar_provider.dart';
import 'package:restaurantcity3/provider/database_provider.dart';
import 'package:restaurantcity3/provider/list_restaurant_provider.dart';
import 'package:restaurantcity3/provider/schedule_provider.dart';
import 'package:restaurantcity3/provider/search_provider.dart';
import 'package:restaurantcity3/provider/shared_preferances_provider.dart';
import 'package:restaurantcity3/ui/detail_screen.dart';
import 'package:restaurantcity3/ui/home_screen.dart';
import 'package:restaurantcity3/ui/search_screen.dart';
import 'package:restaurantcity3/ui/splash_screen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => BottomNavBar(),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            ListRestaurantProvider(restaurantApi: ApiService()),
      ),
      ChangeNotifierProvider(
        create: (context) => DatabaseProvider(
          databaseHelper: DatabaseHelper(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ScheduleProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SharedPreferencesProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            SearchProvider(restaurantApi: ApiService()),
      ),
    ],
      child:   MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          DetailScreen.routeName: (context) => DetailScreen(id: ModalRoute.of(context)?.settings.arguments as String),
          SearchScreen.routeName: (context) => const SearchScreen(),
        },
      ),
    );
  }
}
