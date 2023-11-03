import 'dart:ui';

class ChartModel {

  ChartModel({
    required this.x,
    required this.y,
    this.color
  });

  final String x;
  final double y;
  final Color? color;

}

class FilterChart {
  String startDate;
  String endDate;
  bool? isReturn;
  bool? isDiscount;
  int? selectsCat;
  FilterChart ({
    required this.startDate,
    required this.endDate,
    this.isReturn,
    this.isDiscount,
    this.selectsCat
  });
}

class Selects {
  String label;
  dynamic value;
  dynamic? key;
  Selects({required this.label, required this.value, this.key});
}