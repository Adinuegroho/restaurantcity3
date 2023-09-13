import 'dart:async';
import 'dart:developer' as developer;

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/main.dart';
import 'package:restaurantcity3/provider/bottom_navbar_provider.dart';
import 'package:restaurantcity3/ui/detail_screen.dart';
import 'package:restaurantcity3/utils/network_disconnected.dart';
import 'package:restaurantcity3/utils/notification_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
      _notificationHelper.configureSelectionNotificationSubject(
          context, DetailScreen.routeName);
    });
    initConnectivity();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    subscription.cancel();
    super.dispose();
  }

  final List<BottomNavyBarItem> _navyBarItems = [
    BottomNavyBarItem(
      icon: Icon(MdiIcons.home),
      title: const Text('Home'),
      activeColor: Colors.blue,
    ),
    BottomNavyBarItem(
      icon: Icon(MdiIcons.heart),
      title: const Text('Favorite'),
      activeColor: Colors.redAccent,
    ),
    BottomNavyBarItem(
      icon: Icon(MdiIcons.account),
      title: const Text('Profile'),
      activeColor: Colors.blueAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBar>(
      builder: (context, page, child) => Scaffold(
        body: _connectionStatus == ConnectivityResult.none
            ? const NetworkDisconnected()
            : page.listWidget[page.currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          child: BottomNavyBar(
            curve: Curves.easeInOut,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            showElevation: false,
            items: _navyBarItems,
            onItemSelected: (index) {
              page.currentPage(index);
            },
            selectedIndex: page.currentIndex,
          ),
        ),
      ),
    );
  }
}
