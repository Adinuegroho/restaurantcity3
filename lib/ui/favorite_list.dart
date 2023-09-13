import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/data/api/api_service.dart';
import 'package:restaurantcity3/provider/database_provider.dart';
import 'package:restaurantcity3/provider/detail_restaurant_provider.dart';
import 'package:restaurantcity3/ui/detail_screen.dart';
import 'package:restaurantcity3/ui/home_screen.dart';
import 'package:restaurantcity3/utils/result_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.blue,
        title: const Text('Favorite', style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<DatabaseProvider>(
                builder: (context, provider, child) {
                  if (provider.state == StatusState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (provider.state == StatusState.noData) {
                    return _noFavoriteResto(context);
                  } else {
                    return _buildList(provider);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noFavoriteResto(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
          ),
          Icon(
            MdiIcons.food,
            size: 75,
            color: const Color(0xffd3d3d3),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'You don\'t have favorite resto',
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
  }

  Widget _buildList(DatabaseProvider provider) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.favorite.length,
        itemBuilder: (context, index) {
          var resto = provider.favorite[index];

          return FavoriteCard(
            restaurantId: resto,
          );
        },
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final String restaurantId;
  const FavoriteCard({Key? key, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.isFavorite(restaurantId),
          builder: (context, snapshot) {
            return ChangeNotifierProvider<DetailRestaurantProvider>(
              create: (context) => DetailRestaurantProvider(
                restaurantApi: ApiService(),
                id: restaurantId,
              ),
              child: Consumer<DetailRestaurantProvider>(
                builder: (context, state, child) {
                  if (state.state == StatusState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.state == StatusState.hasData) {
                    return _buildItem(context, state);
                  } else {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, DetailRestaurantProvider detailProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName, arguments: restaurantId);
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
                    tag: detailProvider.detail.restaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      child: Image.network("https://restaurant-api.dicoding.dev/images/small/${detailProvider.detail.restaurant.pictureId}",
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
                          detailProvider.detail.restaurant.name,
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
                              detailProvider.detail.restaurant.city,
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
                              detailProvider.detail.restaurant.rating.toString(),
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
