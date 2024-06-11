import 'package:cookbookpro/utils/size_utils.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String TextFelidHeadline;
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final TextInputType inputType;
  final bool obscureText;
  String? errorText;
  String? Function(String?)? validator;

  CustomTextField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.baseColor,
      required this.borderColor,
      required this.errorColor,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.errorText,
      this.validator,
      required this.TextFelidHeadline});

  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.TextFelidHeadline,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        5.ph,
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: currentColor, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              obscureText: widget.obscureText,
              validator: widget.validator,
              keyboardType: widget.inputType,
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
