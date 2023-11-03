import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    this.price,
    this.category,
    this.size,
    this.color,
    this.dateTime,
    this.isSqflite,
  });

  final String image, title, description;
  final String? category;
  final int? size;
  final int id;
  final Color? color;
  final dynamic? price;
  final dynamic? dateTime;
  final int? isSqflite;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    category: json["category"] ?? '',
    price: json["price"] ?? 0.00,
    description: json["description"] ?? '',
    image: json["image"] ?? '',
    dateTime: json["date_time"] ?? '',
    isSqflite: json["is_sqf_lite"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category": category,
    "price": price,
    "description": description,
    "image": image,
    "date_time": dateTime,
    "is_sqf_lite": isSqflite
  };

  static List<Product> listFromJson(List? json) => (json ?? []).map((e) => Product.fromJson(e)).toList();

  static empty() => Product(id: 0,price: 0.00, category: '', title: '', description: '',image: '',dateTime: null, isSqflite: 0);

  static List Colors = [
    Color(0xFF3D82AE),
    Color(0xFFD3A984),
    Color(0xFF989493),
    Color(0xFFE6B398),
    Color(0xFFFB7883),
    Color(0xFFAEAEAE),
    Color(0xFFAEAEAE),
    Color(0xFFAEAEAE),
    Color(0xFFAEAEAE),
    Color(0xFFAEAEAE)
  ];
}




List<Product> products = [
  Product(
      id: 1,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/bag_1.png",
      color: Color(0xFF3D82AE)),
  Product(
      id: 2,
      title: "Belt Bag",
      price: 234,
      size: 8,
      description: dummyText,
      image: "assets/images/bag_2.png",
      color: Color(0xFFD3A984)),
  Product(
      id: 3,
      title: "Hang Top",
      price: 234,
      size: 10,
      description: dummyText,
      image: "assets/images/bag_3.png",
      color: Color(0xFF989493)),
  Product(
      id: 4,
      title: "Old Fashion",
      price: 234,
      size: 11,
      description: dummyText,
      image: "assets/images/bag_4.png",
      color: Color(0xFFE6B398)),
  Product(
      id: 5,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/bag_5.png",
      color: Color(0xFFFB7883)),
  Product(
    id: 6,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
  ),
  Product(
    id: 7,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
  ),
  Product(
    id: 8,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
  ),
  Product(
    id: 9,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
  ),
  Product(
    id: 10,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
  ),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";