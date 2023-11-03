import 'package:flutter_translate/flutter_translate.dart';

class LanguageModel {
  LanguageModel({
    this.id,
    this.flag,
    this.name,
    required this.lang,
    this.counter,
  });
  final int? id;
  final String? flag,counter,name;
  final String lang;

  static defaultLang() => LanguageModel(lang: 'ru', counter: 'RU');

  factory LanguageModel.initial(){
    return LanguageModel(lang: 'ru', counter: 'RU');
  }

  static List<LanguageModel> languageList() {
    return <LanguageModel>[
      LanguageModel(id: 1, name: translate('language.name.ru'), flag: '🇷🇺', lang: 'ru'),
      LanguageModel(id: 2, name: translate('language.name.en'), flag: '🇬🇧', lang: 'en'),
      LanguageModel(id: 3, name: translate('language.name.zh'), flag: '🇨🇳', lang: 'zh'),
      LanguageModel(id: 4, name: translate('language.name.ar'), flag: '🇦🇪', lang: 'ar'),
    ];
  }
  /*
  *  LanguageModel(id: 1, name: translate('language.name.ru'), flag: '🇷🇺', lang: 'ru'),
      LanguageModel(id: 2, name: translate('language.name.en'), flag: '🇬🇧', lang: 'en'),
      LanguageModel(id: 3, name: translate('language.name.zh'), flag: '🇨🇳', lang: 'zh'),
      LanguageModel(id: 4, name: translate('language.name.ar'), flag: '🇦🇪', lang: 'ar'),*/


}