import 'package:flutter/material.dart';

import '../restaurant.dart';
import '../restaurant_card.dart';
import '../restaurant_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    List pos = [[], []];
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 30; j++) {
        if (RestaurantModel.isFavorite[i][j] == true) {
          pos[0].add(i);
          pos[1].add(j);
        }
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite Restaurants'),
          backgroundColor: Color.fromARGB(255, 104, 192, 157),
        ),
        body: FutureBuilder(
            future: RestaurantModel.findFavoriteRestaurant(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final restaurants = snapshot.data as List<Restaurant>;
                return ListView.builder(
                    key: UniqueKey(),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      if (restaurants.length != 0) {
                        return RestaurantCard(
                          row: pos[0][index],
                          col: pos[1][index],
                          image: Image.network(
                            restaurants.elementAt(index).imagePath,
                            fit: BoxFit.cover,
                          ),
                          title: restaurants.elementAt(index).title,
                          isFavorite: RestaurantModel.getFavoriteByIndex(
                              pos[0][index], pos[1][index]),
                        );
                      } else {
                        return const Center(
                            child: Text("no favorite restaurant"));
                      }
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
