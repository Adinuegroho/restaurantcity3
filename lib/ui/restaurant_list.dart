import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/data/model/restaurants.dart';
import 'package:restaurantcity3/provider/list_restaurant_provider.dart';
import 'package:restaurantcity3/ui/detail_screen.dart';
import 'package:restaurantcity3/ui/search_screen.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({Key? key}) : super(key: key);

  static const routeName = '/restaurant_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.blue,
        title: const Text('Restaurant App', style: TextStyle(color: Colors.white),),
        actions: [IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
          icon: const Icon(Icons.search, color: Colors.white,),
        ),],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Consumer<ListRestaurantProvider>(
                builder: (context, value, _) {
                  if (value.state == StatusState.loading) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  } else if (value.state == StatusState.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.list.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = value.list.restaurants[index];
                          return _buildItem(context, restaurant);
                        },
                      ),
                    );
                  } else if (value.state == StatusState.noData) {
                    return Center(
                      child: Text(value.message),
                    );
                  } else {
                    return const Center(
                      child: Text('No Internet Connection'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, RestaurantsElement restaurantsElement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName, arguments: restaurantsElement.id);
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
                    tag: restaurantsElement.pictureId,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      child: Image.network("https://restaurant-api.dicoding.dev/images/small/${restaurantsElement.pictureId}",
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
                          restaurantsElement.name,
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
                              restaurantsElement.city,
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
                              restaurantsElement.rating.toString(),
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
