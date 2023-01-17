import 'package:flutter/material.dart';
import 'package:flutter_project/restaurant_model.dart';

class RestaurantCard extends StatefulWidget {
  RestaurantCard({
    Key? key,
    required this.row,
    required this.col,
    required this.image,
    required this.title,
    required this.isFavorite,
  }) : super(key: key);

  final int row;
  final int col;
  final Image image;
  final String title;
  bool isFavorite;

  @override
  // ignore: no_logic_in_create_state
  State<RestaurantCard> createState() => _RestaurantCardState(
      row: row, col: col, image: image, title: title, isFavorite: isFavorite);
}

class _RestaurantCardState extends State<RestaurantCard> {
  _RestaurantCardState({
    required this.row,
    required this.col,
    required this.image,
    required this.title,
    required this.isFavorite,
  });

  final int row;
  final int col;
  final Image image;
  final String title;
  bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  height: 210,
                  width: 400,
                  child: image,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: 25,
                              highlightColor: Color.fromARGB(255, 92, 92, 92),
                              icon: (isFavorite)
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              onPressed: () {
                                setState(() {
                                  if (isFavorite) {
                                    print("remove from favorite");
                                    isFavorite = false;
                                    RestaurantModel.setFavoriteByIndex(
                                        row, col, false);
                                  } else {
                                    print("add to favorite");
                                    isFavorite = true;
                                    RestaurantModel.setFavoriteByIndex(
                                        row, col, true);
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
