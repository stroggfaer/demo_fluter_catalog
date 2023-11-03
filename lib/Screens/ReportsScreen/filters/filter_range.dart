import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/ModelChar/ChartModel.dart';
import 'package:my_catalog/Model/Orders.dart';
import 'package:my_catalog/Shared/checkbox_ui.dart';
import 'package:my_catalog/Shared/dropdown_Input_ul.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/helpers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class FilterRange extends StatefulWidget {
  FilterChart dateRangeCurrent;
  final Function(dynamic value)? onDateRange;
  final Function(bool value)? onDiscount;
  final Function(bool value)? onReturn;
  final Function(dynamic value)? onSelect;
  final VoidCallback onTap;

  FilterRange({ Key? key, required this.dateRangeCurrent, this.onDateRange, required this.onTap, this.onDiscount, this.onReturn, this.onSelect}) : super(key: key);

  @override
  _FilterRangeState createState() => _FilterRangeState();
}

class _FilterRangeState extends State<FilterRange> {


  List<Selects> selects = [
    Selects(
      key: 0,
      value: 0,
      label: "Все",
    ),
  ];

  late dynamic selectValue = 0;
  late bool isDiscount = false;
  late bool isReturn = false;

  @override
  void initState() {
    for(int i = 0; i < categories.length; i++){
      selects.add(
          Selects(
              key: i,
              value: categories[i].id,
              label: categories[i].name,
         ));
    }


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          Container(
              padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
              child:  GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;
                        return AlertDialog(
                          insetPadding: const EdgeInsets.all(10.0),
                          title: const Text("Редактировать"),
                          content: Container(
                            width: width,
                            height: height,
                            constraints: const BoxConstraints(maxWidth: 370.0, maxHeight: 500.0),
                            child: SfDateRangePicker(
                              onSelectionChanged: _onSelectionChanged,
                              selectionMode: DateRangePickerSelectionMode.range,
                              navigationDirection: DateRangePickerNavigationDirection.vertical,
                              //controller: _datePickerController,
                              initialSelectedRange:
                              PickerDateRange(
                                  DateTime.parse(widget.dateRangeCurrent.startDate),
                                  DateTime.parse(widget.dateRangeCurrent.endDate)
                              ),
                              showActionButtons: true,
                              enableMultiView: true,
                              cancelText: 'Отмена',
                              confirmText: 'Выбрать',
                              onSubmit: (value) {
                                if(widget.onDateRange!(value) != null) widget.onDateRange!(value);
                                Navigator.pop(context, false);
                              },
                              onCancel: () {
                                //   Navigator.pop(context);
                                Navigator.pop(context, false);
                              },
                            ),
                          ),
                          // actions: [
                          //   TextButton(
                          //     child: const Text("Отмена"),
                          //     onPressed: (){
                          //       Navigator.pop(context, false);
                          //     },
                          //   ),
                          //   TextButton(
                          //     child: const Text("Сохранить"),
                          //     onPressed: () async{
                          //       Navigator.pop(context, false);
                          //     },
                          //   ),
                          // ],
                        );
                      }
                  );
                },
                // DateFormat('dd/MM/yyyy').format(widget.dateRangeCurrent.startDate);

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Период',style: ThemeText.textFontSize(color: Styles.grey, fontSize: 16)),
                    Text('${ Helpers.dateFormatter(date: widget.dateRangeCurrent.startDate)} - ${Helpers.dateFormatter(date: widget.dateRangeCurrent.endDate)}',style: ThemeText.textFontSize(color: Colors.blue, fontSize: 16)),
                  ],
                )
              ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child:  DropdownInputUl(
              options: selects,
              placeholder: 'Выберите категории',
              value: selectValue,
              label: 'Продажи по категории',
              onChanged: (value) {
                setState(() {
                  selectValue = value;
                });
                widget.onSelect!(selectValue);
              },
              // getEmpty: (dynamic value) => value,
            ),
          ),
          Container(
             padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
             child: CheckboxUl(
                label: 'Товар со скидкой',
                value: isDiscount,
                onChanged: (v) {
                  setState(() {
                    isDiscount = v!;
                  });
                  widget.onDiscount!(isDiscount);
                },
              )
          ),
        //   Container(
        //     padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
        //     child: CheckboxUl(
        //       label: 'Возврат товара',
        //       value: isReturn,
        //       onChanged: (v) {
        //         setState(() {
        //           isReturn = v!;
        //         });
        //         widget.onReturn!(isReturn);
        //       },
        //     )
        // ),
          ElevatedButton(onPressed: () => widget.onTap(),
          child: const Text("Применить")),
        const SizedBox(
          height: 10.0,
        )
      ],);
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
  }
}
