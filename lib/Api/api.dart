import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_catalog/Model/ApiResponse.dart';
import 'package:my_catalog/Model/Product.dart';
import 'package:my_catalog/Model/User.dart';
import 'package:my_catalog/Services/db.dart';
import 'package:my_catalog/Shared/network_error.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:translator/translator.dart';

import '../Model/AppState.dart';
import '../Redux/index.dart';

class ApiClient {
  static Dio dio = getDioClient();

  static getDioClient() {
    // customization
    return Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com/', headers: ApiClient.header, contentType: 'application/json'))
      ..interceptors.addAll([
        ApiClient.onInterceptor,
        PrettyDioLogger(
            requestHeader: false,
            requestBody: false,
            responseBody: false,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90)
      ]);
  }
  static OnInterceptor onInterceptor = OnInterceptor();

  static Map<String, String> header = {
    'accept': 'application/json',
  };


  static bool hasLogging = true;

  static toJson() => {
    "header": header
  };
}

class OnInterceptor extends Interceptor {

  // Ошибки глобальный
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    //showConnected(err);
    return super.onError(err, handler);
  }

}

class EffectLoading {
  static init() async {
    // GlobalStore.store
  //  await userCubit.loading()
    //GlobalStore.store.dispatch(FetchUserAction());
   final store = StoreProvider.of<AppState>(navigatorKey.currentContext!, listen: false);
   store.dispatch(FetchUserAction());
  }

  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
        // throw Exception(error);
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return false;
  }
}

class Api {
  // Получить каталог;
  Future<ApiResponse<List<Product>>>fetchProducts() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("api_products_cache");
    var isConnected = await EffectLoading.isConnected();
    print('+++isConnected+++ $isConnected');
    print('+++isCacheExist+++ $isCacheExist');
    try {
      // if(isConnected == false && isCacheExist == true)
      if(isConnected == false && isCacheExist == true) {
        var cacheData = await APICacheManager().getCacheData("api_products_cache");
        print('CACHE HIT');
        //print(test[0].image);
        return ApiResponse(Product.listFromJson(json.decode(cacheData.syncData)));
      }else{
        final res = await ApiClient.dio.get('/products');
        var response = [];
        //TODO Задача sqflite
        var sqflite = await DB.queryAll();
        if(sqflite.isNotEmpty) {
          print('fetchProducts sqflite: $sqflite');
          response = [...sqflite, ...res.data];
        }else {
          response = [...res.data];
        }
        // Добавляем в кэш апи;
        APICacheDBModel cacheDBModel = APICacheDBModel(
          key: 'api_products_cache',
          syncData: jsonEncode(response),
        );
        print('URL HIT');
        //deleteCache(keyName)

        await APICacheManager().addCacheData(cacheDBModel);
        return ApiResponse(Product.listFromJson(response));
      }
    }catch(error, st) {
      // showConnected(error);
      if (error is DioError) {
        print(error);
        throw Exception(error);
      } else {
        print(error);
        throw Exception(error);
      }
    }

  }

  // Просмотра катлаог;
  Future<ApiResponse<Product>>viewProducts({required int id}) async {

    var isConnected = await EffectLoading.isConnected();
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("api_products_cache_id_$id");
    //  if(isConnected == false && isCacheExist == true) {
    try {
      if(isConnected == false && isCacheExist == true) {
        var cacheData = await APICacheManager().getCacheData("api_products_cache_id_$id");
        print('CACHE VIEW HIT');
        return ApiResponse(Product.fromJson(json.decode(cacheData.syncData)));
      }else{
        late final res;
        //TODO локальный БД;
        var sqflite = await DB.queryOne(id);
        if(sqflite.isNotEmpty) {
           res = sqflite[0];
        }else{
           var response = await ApiClient.dio.get('/products/$id');
           res = response.data;
        }
        // Добавляем в кэш апи;
        APICacheDBModel cacheDBModel = APICacheDBModel(
          key: "api_products_cache_id_$id",
          syncData: jsonEncode(res),
        );
        print('URL VIEW HIT');
        //deleteCache(keyName)
        await APICacheManager().addCacheData(cacheDBModel);
        return ApiResponse(Product.fromJson(res));

      }

    }catch(error, st) {

      if (error is DioError) {
        throw Exception(error);
      } else {
        throw Exception(error);
      }
    }
  }

  // Добавить продукт
  Future<Object>addProductPost({required String title,description,image,category, required double price}) async {
    final Map<String, dynamic> params = {
      'title' : title,
      'price': price,
      "description": description,
      "image": image,
      "category": category
    };
    try {
      var res = await ApiClient.dio.post('/products', data: params);
      print('addProductPost $res');
      return res;
    }catch(error) {
      throw Exception(error);
    }
  }

  // Загрузка узер;
  Future<ApiResponse<User>>fetchUser() async {
    // Мок;
    var json =  {
      "id":1,
      "name":"Иванов Петрович",
      "age": 12,
    };

    try {
      await Future.delayed(const Duration(seconds: 3));
      final res = await Future.value(json);
      return ApiResponse(User.fromJson(res));
    }catch(error, st) {
      if (error is DioError) {
        throw Exception(error);
      } else {
        throw Exception(error);
      }
    }
  }

  // TEST;
  Future<double> getPrices() async {
    var random = Random();
    int randomInt = random.nextInt(1000);
    double randTemp = random.nextDouble() * randomInt;
    // Мок;
    var json =  {
      "price":randTemp,
    };
    try {
      await Future.delayed(const Duration(seconds: 1));
      final res = await Future.value(json);
      print(res);
      final price = double.parse(res['price'].toString());
      return price;
    }catch(error, st) {
      if (error is DioError) {
        throw Exception(error);
      } else {
        throw Exception(error);
      }
    }

  }

  //
  static Future<String> translateGoogle(String text, String local) async {
    /*
    final translation = await GoogleTranslator().translate(
      message,
      from: fromLanguageCode,
      to: toLanguageCode,
    );

    return translation.text;
     */

    if(text == null) {
      return text;
    }

    try{
      var translationRes = await text.translate(to: local);
      return translationRes.text;
    }catch(e) {
      print('error translateGoogle $e');
      return text;
    }
  }

}

class Network {

}



String? responsePattern(Response response) {
  if (response.data != null) {
    return response.data['data']["translations"]['translatedText'];
  }
  return null;
}





showConnected(error) async{
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      // throw Exception(error);
    }
  } on SocketException catch (_) {
    print('not connected');
    alertShowErrorNetwork();
    throw Exception(error);
  }
}
