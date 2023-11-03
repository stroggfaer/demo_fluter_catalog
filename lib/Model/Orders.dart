import 'dart:math';

import 'package:flutter/foundation.dart';

class Orders {
  Orders(
      {
        required this.id,
        required this.image,
        required this.title,
        required this.description,
        required this.category,
        this.isReturnGood,
        this.price,
        this.isDiscount,
        this.size,
        this.dateTime,
        this.isSqflite,
        required this.counts
      }
   );

  final String image, title, description;
  final int category;
  final bool? isDiscount;
  final int? size;
  final int id;
  final int counts;
  final dynamic? price;
  final dynamic? dateTime;
  final int? isSqflite;
  final bool? isReturnGood;
}

class Category {
  final int id;
  final String name;
  Category({required this.id, required this.name});
}

class Reports {
  final String year;
  List<Months> months;
  Reports({required this.year, required this.months});
}
class Months {
  Months({required this.month, required this.total});
  int month;
  dynamic total;
}

//  Months(month: 1, total: 10032),
List <Reports> reportsBar = [
  Reports(
    year: '2022',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2021',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2020',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2019',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2018',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2017',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2016',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
  Reports(
    year: '2015',
    months: [1,2,3,4,5,6,7,8,9,10,11,12].map((month) {
      var random = Random();
      var price = random.nextInt(100);
      return Months(month: month, total: price);
    }).toList(),
  ),
];

List<Category> categories = [
  Category(
    id: 1001,
    name: 'Одежда'
  ),
  Category(
      id: 1002,
      name: 'Техника'
  ),
  Category(
      id: 1003,
      name: 'Продукты'
  ),
  Category(
      id: 1004,
      name: 'Электроника'
  )
];

List years = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023];

List<Orders> orders = [
  Orders(
      id: 1,
      title: "Office Code",
      price: 8234,
      size: 12,
      category: 1001,
      dateTime: '2022-11-01',
      isDiscount: false,
      description: dummyText,
      image: "assets/images/bag_1.png",
      isReturnGood: false,
      counts: 32
  ),
  Orders(
    id: 2,
    title: "2 Office Code",
    price: 3234,
    size: 12,
    category: 1001,
    dateTime: '2022-11-02',
    isDiscount: false,
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
    counts: 4
  ),
  Orders(
    id: 3,
    title: "3 Office Code",
    price: 2344,
    size: 12,
    category: 1001,
    isDiscount: true,
    dateTime: '2022-11-12',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
      counts: 3
  ),
  Orders(
    id: 4,
    title: "4 Office Code",
    price: 674,
    size: 12,
    category: 1002,
    isDiscount: true,
    dateTime: '2022-10-12',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
      counts: 2
  ),
  Orders(
    id: 5,
    title: "5 Office Code",
    price: 3474,
    size: 12,
    category: 1002,
    isDiscount: true,
    dateTime: '2022-10-13',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
      counts: 6,
  ),
  Orders(
    id: 6,
    title: "6 Office Code",
    price: 5556,
    size: 12,
    category: 1002,
    isDiscount: false,
    dateTime: '2022-11-07',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
    counts: 30
  ),

  Orders(
    id: 7,
    title: "7 Office Code",
    price: 956,
    size: 12,
    category: 1003,
    isDiscount: false,
    dateTime: '2022-12-02',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
    counts: 2,
  ),
  Orders(
    id: 8,
    title: "8 Office Code",
    price: 526,
    size: 12,
    category: 1003,
    isDiscount: true,
    dateTime: '2022-11-09',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 3,
  ),
  Orders(
    id: 9,
    title: "7 Office Code",
    price: 426,
    size: 12,
    category: 1003,
    isDiscount: true,
    dateTime: '2022-11-10',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 2,
  ),

  Orders(
    id: 10,
    title: "10 Office Code",
    price: 236,
    size: 12,
    category: 1004,
    isDiscount: true,
    dateTime: '2022-09-03',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 2,
  ),
  Orders(
    id: 11,
    title: "11 Office Code",
    price: 4236,
    size: 12,
    category: 1004,
    isDiscount: true,
    dateTime: '2022-09-04',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: false,
    counts: 6,
  ),
  Orders(
    id: 12,
    title: "12 Office Code",
    price: 5233,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-09-07',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 6,
  ),
  Orders(
    id: 13,
    title: "13 Office Code",
    price: 9236,
    size: 12,
    category: 1004,
    isDiscount: true,
    dateTime: '2022-11-14',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
  Orders(
    id: 14,
    title: "14 Office Code",
    price: 3236,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-11-13',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
  Orders(
    id: 15,
    title: "15 Office Code",
    price: 3236,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-11-12',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
  Orders(
    id: 16,
    title: "16 Office Code",
    price: 936,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-11-10',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
  Orders(
    id: 17,
    title: "17 Office Code",
    price: 2936,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-11-01',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
  Orders(
    id: 18,
    title: "18 Office Code",
    price: 5936,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-11-02',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
  Orders(
    id: 19,
    title: "19 Office Code",
    price: 5936,
    size: 12,
    category: 1004,
    isDiscount: false,
    dateTime: '2022-11-03',
    description: dummyText,
    image: "assets/images/bag_1.png",
    isReturnGood: true,
    counts: 4,
  ),
];


String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";