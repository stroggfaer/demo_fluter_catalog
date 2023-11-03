import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_catalog/Shared/network_error.dart';
import 'package:my_catalog/Utils/translate_preferences.dart';
import 'package:translator/translator.dart';

class Helpers {
  bool isOpenErrorNetwork = false;

  showModal(BuildContext context, {required String message, required loading}) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: false,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading) ...[Text('Загрузка...'), const SizedBox(height: 16)],
              Text(message),
            ],
          ),
        );
      },
    );
  }



  // Ведущие нули
  static numberNull(int num) {
    return num.toString().padLeft(2, '0');
  }

  alertShow({required BuildContext context, required String message}) {
    clearSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
    );
  }

  static dateFormatter({dynamic date, String format = 'dd.MM.yyyy'}) {
    DateTime _date;
    if (date is String) {
      _date = DateTime.parse(date);
    } else {
      _date = date;
    }
    return DateFormat(format).format(_date).toString();
  }

  // Проверить;
  static translateGoogle({String? text}) async {
    if(text == null) {
      return text;
    }
    try{
      // final translator = GoogleTranslator();
      var local = await TranslatePreferences().getPreferredLocale();
      var _local  = local.toString().replaceFirst(RegExp('zh'), 'zh-cn');
       var translationRes = await text.translate(to: _local);
      // return translationRes?.text ?? '+';
      return translationRes.text;
    }catch(e) {
      print('error translateGoogle $e');
      return text;
    }
  }


}

