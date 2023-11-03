import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Model/LanguageModel.dart';
import 'package:my_catalog/Redux/ThunkActionApi.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:redux/redux.dart';


class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    final Store <AppState> store = StoreProvider.of(context);

    return Scaffold(
      // appBar: AppBar(title: Text(Locales.string(context, 'setting'))),
      appBar: headerAppBar(context, titleAppBar:translation(context).language),
      // with extension
      // appBar: AppBar(title: Text(context.localeString('setting'))),
      body: Column(
        children: LanguageModel.languageList().map((item) {
          var selected = identical(item.lang, currentLocale.toString());
          return  ListTile(
            dense: false,
            selected: selected,
            selectedTileColor: Styles.purple,
            onTap: () async {
              // print('click ${item.id}');
              // Navigator.pop(context);

              await setLanguageAction(store, item.lang);
            },
            title: Text('${item.flag} ${item.name}',style: ThemeText.textFontSize(color: selected ? Styles.white : Styles.black, fontSize: 16)),
          );
        }).toList()
      ),
    );
  }
}
