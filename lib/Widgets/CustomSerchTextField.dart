import 'package:cookbookpro/utils/imageConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final TextInputType inputType;
  final bool obscureText;

  String? errorText;

  CustomSearchTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.baseColor,
    required this.borderColor,
    required this.errorColor,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
  });

  _CustomSearchTextFieldState createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 255,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: TextFormField(
            style: Theme.of(context).textTheme.displaySmall,
            obscureText: widget.obscureText,
            keyboardType: widget.inputType,
            controller: widget.controller,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset(ImageConstant.serch_icon,scale: 30,),
              ),
             border: InputBorder.none,
              hintText: widget.hint,
            ),
          ),
        ),
      ),
    );
  }
}
