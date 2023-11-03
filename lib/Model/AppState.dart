import 'package:flutter/cupertino.dart';
import 'package:my_catalog/Model/Basket.dart';
import 'package:my_catalog/Model/LanguageModel.dart';
import 'package:my_catalog/Model/User.dart';

class AppState {
  List<Basket> basket;
  User? user;
  Exception? error;
  bool? isConnectivity;
  int counts;
  bool isSpinner;
  LanguageModel language;


  AppState({
    this.basket = const [],
    this.user,
    this.counts = 0,
    this.error,
    this.isConnectivity,
    this.isSpinner = false,
    required this.language
  });
}


