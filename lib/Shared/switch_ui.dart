import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Styles/styles.dart';

class SwitchUl extends StatefulWidget {
  final bool value;
  final bool disabled;
  final double size;
  final String? label;
  // final ValueChanged<bool?> onChanged;
  final Function(bool?)? onChanged;
  final Function(bool?)? onTap;

  const SwitchUl({
    Key? key,
    this.onChanged,
    this.size = 24,
    this.value = false,
    this.disabled = false,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  _SwitchUlState createState() => _SwitchUlState();
}

class _SwitchUlState extends State<SwitchUl> {

  late bool isCheckedSwitch;

  @override
  void initState() {
    setState(() => isCheckedSwitch = widget.value);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            disabledColor: Colors.blue.withOpacity(0.6),
            unselectedWidgetColor: Colors.transparent //Styles.greyNormal, // Colors.transparent
        ),
        child: Row(
          children: [
            SizedBox(
                width: widget.size,
                height: widget.size,
                child: Transform.scale(
                  scale: widget.size / Checkbox.width,
                  child: Switch(
                      activeColor: Colors.blue,
                      value: widget.value,
                      onChanged: (value) => {
                        setState(() => isCheckedSwitch = value),
                        widget.disabled ? null : widget.onChanged!(value)
                      }
                  ),
                )
            ),
            if(widget.label != null)  Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child:  GestureDetector(
                  child: Text('${widget.label}', style: ThemeText.textFontSize(color: Styles.black,fontSize: 16), textAlign: TextAlign.left),
                  onTap: () {
                    setState(() => isCheckedSwitch = !isCheckedSwitch);
                    widget.disabled ? null : widget.onChanged!(isCheckedSwitch);
                  }
              ),
            )
          ],
        )
    );
  }
}