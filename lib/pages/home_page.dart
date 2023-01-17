import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../restaurant.dart';
import '../restaurant_card.dart';
import '../restaurant_model.dart';

const double _kItemExtent = 32.0;
const List<String> _categories = <String>[
  'All',
  '曼谷',
  '嘉義',
  '花蓮',
  '台南',
  '台北',
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  var restaurants;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 300,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Restaurants'),
          backgroundColor: Color.fromARGB(255, 104, 192, 157),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite');
              },
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('Categories : ',
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          selectedCategory = selectedItem;
                        });
                      },
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedCategory),
                      children: List<Widget>.generate(_categories.length,
                          (int index) {
                        return Center(
                          child: Text(
                            _categories[index],
                          ),
                        );
                      }),
                    ),
                  ),
                  child: Text(
                    _categories[selectedCategory],
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(255, 33, 90, 67),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedCategory == 0) ...[
              Expanded(child: allRestaurant())
            ] else ...[
              Expanded(
                child: FutureBuilder(
                    future: RestaurantModel.getRestaurant(selectedCategory),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        restaurants = snapshot.data as List<Restaurant>;
                        return SizedBox(
                          height: 210.0,
                          child: RefreshIndicator(
                            onRefresh: _refresh,
                            child: cityRestaurant(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              )
            ],
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    print('refresh');
    setState(() {
      restaurants = RestaurantModel.getRestaurant(selectedCategory);
    });
  }

  Widget cityRestaurant() {
    return ListView.builder(
        key: UniqueKey(),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          int col = index;
          return RestaurantCard(
            row: selectedCategory - 1,
            col: col,
            image: Image.network(restaurants.elementAt(col).imagePath,
                fit: BoxFit.cover),
            title: restaurants.elementAt(col).title,
            isFavorite:
                RestaurantModel.getFavoriteByIndex(selectedCategory - 1, col),
          );
        });
  }

  Widget allRestaurant() {
    return ListView.builder(
      key: UniqueKey(),
      itemCount: 10,
      itemBuilder: (context, index) {
        final int row = (index / 2).toInt();
        String title = '曼谷';
        if (index % 2 == 0) {
          if (row == 1) {
            title = '嘉義';
          } else if (row == 2) {
            title = '花蓮';
          } else if (row == 3) {
            title = '台南';
          } else if (row == 4) {
            title = '台北';
          }
          return Padding(
            padding: EdgeInsets.all(10),
            child: Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                )),
          );
        } else {
          return FutureBuilder(
              future:
                  //row+1 為selectedCategory
                  RestaurantModel.getRestaurant(row + 1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final restaurants = snapshot.data as List<Restaurant>;
                  return SizedBox(
                    height: 210.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        key: UniqueKey(),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          int col = index;
                          return RestaurantCard(
                            row: row,
                            col: col,
                            image: Image.network(
                                restaurants.elementAt(col).imagePath,
                                fit: BoxFit.cover),
                            title: restaurants.elementAt(col).title,
                            isFavorite:
                                RestaurantModel.getFavoriteByIndex(row, col),
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              });
        }
      },
    );
  }
}
