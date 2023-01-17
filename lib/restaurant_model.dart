import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/pages/search_page.dart';
import 'package:flutter_project/restaurant_card.dart';

import 'restaurant.dart';
import 'package:http/http.dart' as http;

class RestaurantModel {
  static const imagePathes = [
    [
      'asset/rest1.jpg',
      'asset/rest2.jpg',
      'asset/rest3.jpg',
    ],
    [
      'asset/rest4.jpg',
      'asset/rest5.jpg',
      'asset/rest6.jpg',
    ],
    [
      'asset/rest7.jpg',
      'asset/rest8.jpg',
      'asset/rest9.jpg',
    ],
  ];

  static const titles = [
    [
      '元氣飯糰',
      '福屋拉麵',
      'Veganday',
    ],
    [
      '愛克爾法式',
      '青子Aoko',
      '良心製菓',
    ],
    [
      '小佐茶作',
      '得正',
      '吃茶三千',
    ],
  ];

  static var dataBangkok;
  static var dataChaiyi;
  static var dataHwalian;
  static var dataTainan;
  static var dataTaipei;

  static var isFavorite = [
    [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ]
  ];

  static bool getFavoriteByIndex(int row, int col) {
    return isFavorite[row][col];
  }

  static setFavoriteByIndex(int row, int col, bool isFav) {
    isFavorite[row][col] = isFav;
  }

  static Future<List<Restaurant>> getRestaurant(int selectedCategory) async {
    switch (selectedCategory) {
      case 1:
        if (dataBangkok == null) {
          final res = await http
              .get(Uri.parse('http://127.0.0.1:5000/restaurant/Bangkok'));
          if (res.statusCode == 200) {
            dataBangkok = jsonDecode(res.body);
          } else {
            throw Exception('failed to load restaurant:${res.body}');
          }
        }
        final json = dataBangkok;
        final results = json['results']['data'] as List;
        final restaurants = results.map((e) => Restaurant.fromJson(e)).toList();
        return restaurants;
      case 2:
        if (dataChaiyi == null) {
          final res = await http
              .get(Uri.parse('http://127.0.0.1:5000/restaurant/chaiyi'));
          if (res.statusCode == 200) {
            dataChaiyi = jsonDecode(res.body);
          } else {
            throw Exception('failed to load restaurant:${res.body}');
          }
        }
        final json = dataChaiyi;
        final results = json['results']['data'] as List;
        final restaurants = results.map((e) => Restaurant.fromJson(e)).toList();
        return restaurants;
      case 3:
        if (dataHwalian == null) {
          final res = await http
              .get(Uri.parse('http://127.0.0.1:5000/restaurant/hwalian'));
          if (res.statusCode == 200) {
            dataHwalian = jsonDecode(res.body);
          } else {
            throw Exception('failed to load restaurant:${res.body}');
          }
        }
        final json = dataHwalian;
        final results = json['results']['data'] as List;
        final restaurants = results.map((e) => Restaurant.fromJson(e)).toList();
        return restaurants;
      case 4:
        if (dataTainan == null) {
          final res = await http
              .get(Uri.parse('http://127.0.0.1:5000/restaurant/tainan'));
          if (res.statusCode == 200) {
            dataTainan = jsonDecode(res.body);
          } else {
            throw Exception('failed to load restaurant:${res.body}');
          }
        }
        final json = dataTainan;
        final results = json['results']['data'] as List;
        final restaurants = results.map((e) => Restaurant.fromJson(e)).toList();
        return restaurants;
      case 5:
        if (dataTaipei == null) {
          final res = await http
              .get(Uri.parse('http://127.0.0.1:5000/restaurant/taipei'));
          if (res.statusCode == 200) {
            dataTaipei = jsonDecode(res.body);
          } else {
            throw Exception('failed to load restaurant:${res.body}');
          }
        }
        final json = dataTaipei;
        final results = json['results']['data'] as List;
        final restaurants = results.map((e) => Restaurant.fromJson(e)).toList();
        return restaurants;
      default:
        throw Exception('unknown category');
    }
  }

  static Future<List<Restaurant>> findFavoriteRestaurant() async {
    List<Restaurant> favs = <Restaurant>[];

    for (int i = 0; i < 5; i++) {
      final restaurants = await getRestaurant(i + 1);
      for (int j = 0; j < 30; j++) {
        if (isFavorite[i][j] == true) {
          favs.add(restaurants[j]);
        }
      }
    }
    return favs;
  }

  static List search_pos = [[], []];
  static String search_results = "";

  static Future<List<Restaurant>> searchRestaurant(String key) async {
    List<Restaurant> searched = <Restaurant>[];
    search_pos = [[], []];
    search_results = "";
    if (key == "") return searched;
    for (int i = 0; i < 5; i++) {
      final restaurants = await getRestaurant(i + 1);
      for (int j = 0; j < 30; j++) {
        if (restaurants.elementAt(j).title.contains(key)) {
          searched.add(restaurants[j]);
          search_pos[0].add(i);
          search_pos[1].add(j);
          search_results += restaurants.elementAt(j).title;
          search_results += " ";
        }
      }
    }
    return searched;
  }
}
