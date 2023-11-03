import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Styles/styles.dart';

class stCheckboxUl extends StatelessWidget {
  final bool value;
  final bool disabled;
  final double size;
  final String? label;
  final Function(bool?)? onChanged;
  const stCheckboxUl({
    Key? key,
    this.onChanged,
    this.size = 17,
    this.value = false,
    this.disabled = false,
    this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxColor = disabled ?  Styles.greyWhite : Styles.greyNormal;
    final checkColor = disabled ? Styles.white : Colors.white;
    return Theme(
      data: Theme.of(context).copyWith(
          disabledColor: Styles.greyWhite,
          unselectedWidgetColor: Colors.transparent //Styles.greyNormal,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: boxColor),
                borderRadius: BorderRadius.circular(3),
              ),
              clipBehavior: Clip.hardEdge,
              child: Transform.scale(
                scale: size / Checkbox.width,
                child: Checkbox(
                    activeColor: Styles.blue,
                    checkColor: checkColor,
                    value: value,
                    onChanged: disabled ? null : onChanged
                ),
              ),
            ),
          ),
         if(label != null) Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child:  Text('$label', style: ThemeText.textFontSize(color: Styles.black,fontSize: size), textAlign: TextAlign.left),
          )
        ],
      )
    );
  }
}

class CheckboxUl extends StatefulWidget {

  final bool value;
  final bool disabled;
  final double size;
  final String? label;
  final Function(bool?)? onChanged;

  const CheckboxUl({
    Key? key,
    this.onChanged,
    this.size = 17,
    this.value = false,
    this.disabled = false,
    this.label
  }) : super(key: key);

  @override
  _CheckboxUlState createState() => _CheckboxUlState();
}

class _CheckboxUlState extends State<CheckboxUl> {

  late bool isChecked;

  @override
  void initState() {
    setState(() => isChecked = widget.value);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boxColor = widget.disabled ?  Styles.greyWhite : Styles.greyNormal;
    final checkColor = widget.disabled ? Styles.white : Colors.white;
    return Theme(
        data: Theme.of(context).copyWith(
            disabledColor: Styles.greyWhite,
            unselectedWidgetColor: Colors.transparent //Styles.greyNormal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: boxColor),
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.hardEdge,
                child: Transform.scale(
                  scale: widget.size / Checkbox.width,
                  child: Checkbox(
                      activeColor: Styles.blue,
                      checkColor: checkColor,
                      value: widget.value,
                      onChanged: (value) => {
                        setState(() => isChecked = widget.value),
                        widget.disabled ? null : widget.onChanged!(value)
                      }
                  ),
                ),
              ),
            ),
            if(widget.label != null) Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child:   GestureDetector(
                  child: Text('${widget.label}', style: ThemeText.textFontSize(color: Styles.black,fontSize: widget.size), textAlign: TextAlign.left),
                  onTap: () {
                    setState(() => isChecked = !isChecked);
                    widget.disabled ? null : widget.onChanged!(isChecked);
                  }
              )
            )
          ],
        )
    );
  }
}
