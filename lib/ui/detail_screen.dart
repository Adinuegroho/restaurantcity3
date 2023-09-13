import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/provider/database_provider.dart';
import 'package:restaurantcity3/provider/detail_restaurant_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  static const routeName = '/restaurant_detail';

  final String id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailRestaurantProvider>(
      create: (context) => DetailRestaurantProvider(
        restaurantApi: ApiService(),
        id: widget.id,
      ),
      child: Scaffold(
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
              "Detail Restaurant",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        body: Consumer<DetailRestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == StatusState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == StatusState.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(
                          color: const Color(0xffF4F4F4),
                          width: double.infinity,
                          child: Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14.0),
                                  bottomRight: Radius.circular(14.0),
                                ),
                                child: Image.network("https://restaurant-api.dicoding.dev/images/large/${state.detail.restaurant.pictureId}",
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.detail.restaurant.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30,
                                              color: Color(0xff333740)),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_sharp,
                                              color: Colors.red,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              state.detail.restaurant.city,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff828285)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Consumer<DatabaseProvider>(
                                    builder: (context, provider, child) {
                                      return FutureBuilder(
                                        future: provider
                                            .isFavorite(state.detail.restaurant.id),
                                        builder: (context, snapshot) {
                                          var isFavorite = snapshot.data ?? false;
                                          if (isFavorite == true) {
                                            return IconButton(
                                              onPressed: () {
                                                provider.removeFavorite(
                                                    state.detail.restaurant.id);
                                                Fluttertoast.showToast(
                                                  msg:
                                                  '${state.detail.restaurant.name} removed from favorite',
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                MdiIcons.heartCircle,
                                                size: 50,
                                                color: Colors.redAccent,
                                              ),
                                            );
                                          } else {
                                            return IconButton(
                                              onPressed: () {
                                                provider.addFavorite(
                                                    state.detail.restaurant.id);
                                                Fluttertoast.showToast(
                                                  msg:
                                                  '${state.detail.restaurant.name} added to favorite',
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                MdiIcons.heartCircleOutline,
                                                size: 50,
                                                color: Colors.redAccent,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xffFFC41F),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        state.detail.restaurant.rating.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff333740)
                                        ),
                                      )
                                    ],
                                  )

                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                "Description",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff333740)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.detail.restaurant.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff828285)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 16.0, 0.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Foods',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: state.detail.restaurant.menus.foods.map(
                                        (menu) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: const DecorationImage(
                                                image: NetworkImage('https://picsum.photos/id/493/200/300'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  menu.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Drinks',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: state.detail.restaurant.menus.drinks.map(
                                        (menu) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: const DecorationImage(
                                                image: NetworkImage('https://picsum.photos/id/755/200/300'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  menu.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            } else if (state.state == StatusState.noData) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text('No Internet Connection'),
              );
            }
          },
        ),
      ),
    );
  }
}




