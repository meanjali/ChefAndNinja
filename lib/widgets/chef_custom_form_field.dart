import 'package:flutter/material.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class CustomFormField extends StatelessWidget {
  final Function onChanged;
  final String labelText;
  final String validatorStr;
  final IconData prefixicon;
  final FocusScopeNode node;
 String type="";


  CustomFormField({
    @required this.onChanged,
    @required this.labelText,
    @required this.validatorStr,
    @required this.prefixicon,
    @required this.node,
    this.type
  })  : assert(labelText != null),
        // assert(onChanged != null),
        assert(validatorStr != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextFormField(
        onEditingComplete: node.nextFocus,
        validator: (value) {
          if (value.length == 0) {
            return (validatorStr);
          }
          return null;
        },
        keyboardType: type=="num"?TextInputType.number:null,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixicon,
            color: kMainColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: kMainColor, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: BorderSide(color: kMainColor),
          ),
          labelStyle: new TextStyle(color: headingColor, fontSize: 15),
          labelText: labelText,
        ),
      ),
    );
  }
}
