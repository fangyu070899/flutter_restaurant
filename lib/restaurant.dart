import 'package:flutter_project/restaurant_model.dart';

class Restaurant {
  String title;
  String imagePath;

  Restaurant({
    required this.title,
    required this.imagePath,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    const nullImage =
        'https://us.123rf.com/450wm/ilyakalinin/ilyakalinin1705/ilyakalinin170500016/78167484-the-robot-can-not-find-your-page-error-page-404-not-found-.jpg?ver=6';

    final result = json;
    return Restaurant(
      title: result['name'],
      imagePath: (result['photo'] == null)
          ? nullImage
          : result['photo']['images']['original']['url'],
    );
  }
}
