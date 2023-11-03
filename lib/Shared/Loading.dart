import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Styles/styles.dart';

class Loading extends StatelessWidget {
  final bool loading;
  final bool fullHeight;
  final Color? color;
  final double? size;
  final int border;
  final double? padding;

  const Loading({
    Key? key,
    this.loading = true,
    this.fullHeight = true,
    this.color,
    this.size,
    this.border = 20,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!loading) return const SizedBox();

    final indicator = Center(
        child: SizedBox(
          height: 80,
          width: 80,
          child: CircularProgressIndicator(
              backgroundColor: Styles.greyDark,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? Styles.grey),
              strokeWidth: size != null ? size! / 10 : 5
          ),
        )
    );

    if (fullHeight) {
      return indicator;
    } else {
      return Center(
          child: SizedBox(
            height: size ?? 100,
            width: size ?? 100,
            child: CircularProgressIndicator(
                backgroundColor: Styles.greyDark,
                valueColor: AlwaysStoppedAnimation<Color>(color ?? Styles.grey),
                strokeWidth: size != null ? size! / border : 5
            ),
          )
      );
    }
  }


}