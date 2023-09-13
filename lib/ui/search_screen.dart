import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/data/model/restaurant_search.dart';
import 'package:restaurantcity3/provider/search_provider.dart';
import 'package:restaurantcity3/ui/detail_screen.dart';
import 'package:restaurantcity3/utils/network_disconnected.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = '/search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController textEditingController;
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
    final SearchProvider searchRestaurantProvider =
    Provider.of<SearchProvider>(context, listen: false);

    textEditingController =
        TextEditingController(text: searchRestaurantProvider.query);

    initConnectivity();

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 75,
          backgroundColor: Colors.blue,
          foregroundColor: const Color(0xff333740),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: const Text(
            "Search",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 30),
            child: Column(
              children: [
                Consumer<SearchProvider>(
                  builder: (context, state, _) {
                    return TextField(
                      onChanged: (value) {
                        Provider.of<SearchProvider>(context,
                            listen: false)
                            .searchRestaurant(value);
                      },
                      controller: textEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'eg: Input name restaurant',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Consumer<SearchProvider>(
                  builder: (context, state, _) {
                    if (state.state == StatusState.loading) {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                            const CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else if (state.state == StatusState.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.search.founded.toInt(),
                          itemBuilder: (context, index) {
                            final restaurant = state.search.restaurants[index];
                            return _buildItem(context, restaurant);
                          },
                        ),
                      );
                    } else if (state.state == StatusState.noData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3.5,
                            ),
                            Icon(
                              MdiIcons.storeRemoveOutline,
                              size: 80,
                              color: const Color(0xffd3d3d3),
                            ),
                            const Text(
                              'Couldn\'t find the restaurant you looking for',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffd3d3d3),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                            Icon(
                              MdiIcons.storeSearchOutline,
                              size: 80,
                              color: const Color(0xffd3d3d3),
                            ),
                            const Text(
                              'Search for your favorite restaurants',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffd3d3d3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 30),
            child: Column(
              children: [
                Consumer<SearchProvider>(
                  builder: (context, state, _) {
                    return TextField(
                      onChanged: (value) {
                        Provider.of<SearchProvider>(context,
                            listen: false)
                            .searchRestaurant(value);
                      },
                      controller: textEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'eg: Tempat Siang Hari',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
                const NetworkDisconnected(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildItem(BuildContext context, Restaurant restaurant) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName, arguments: restaurant.id);
        },
        child: SizedBox(
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Hero(
                    tag: restaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      child: Image.network("https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 2.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_sharp,
                              size: 14,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              restaurant.city,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xffFFC41F),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              restaurant.rating.toString(),
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}