import 'package:flutter/material.dart';
import 'package:my_catalog/Model/ModelChar/ChartModel.dart';
import 'package:my_catalog/Styles/styles.dart';

class DropdownInputUl<T> extends StatelessWidget {
  final String? label;
  final List<Selects> options;
  final dynamic? value;
  final Function(T)? getEmpty;
  final Function(dynamic) onChanged;
  final String? placeholder;

  const DropdownInputUl({
    super.key,
    this.label,
    this.options = const [],
    this.getEmpty,
    this.placeholder,
    this.value,
    required this.onChanged,
  });

  // placeholder ?? 'Выберите занчение'
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(label != null)Container(
          padding:  const EdgeInsets.only(bottom: 5.0),
          child: Text(label!, style: ThemeText.textFontSize(color: Styles.grey,fontSize: 16), textAlign: TextAlign.left),
        ),
        FormField<T>(
          builder: (FormFieldState<T> state) {
            return Container(
              decoration: BoxDecoration(
                color: Styles.greyLite,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  hintText: value == null || value == '' ? placeholder ?? 'Выберите занчение' : '',
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent),),
                ),
                isEmpty: value == null || value == '' ? true : false,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                      iconEnabledColor: Styles.blue,
                      value: value == null || value == '' ? null : value,
                      isDense: true,
                      onChanged: onChanged,
                      items: _options()
                  ),
                ),
              ),
            );
          },
        ),
        Container(height: 10.0)
      ],
    );

  }
  _options() {
    if(options.isNotEmpty) {
      return options.map((Selects item) {
        return DropdownMenuItem<T>(
          value: item.value,
          child: Text(item.label),
        );
      }).toList();
    }else{
      return [];
    }

  }
}