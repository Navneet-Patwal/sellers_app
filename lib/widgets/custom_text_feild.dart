import 'package:flutter/material.dart';

class CustomTextFeild extends StatefulWidget {
  TextEditingController? textEditingController;
  IconData? iconData;
  String? hintString;
  bool? isObscure = true;
  bool? enabled = true;
  CustomTextFeild({super.key, this.textEditingController, this.iconData, this.hintString, this.isObscure, this.enabled});

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(12),
      child: TextField(
        style: TextStyle(color: Colors.black),
        enabled: widget.enabled,
        controller: widget.textEditingController,
        obscureText: widget.isObscure!,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.iconData,
            color: Colors.blueAccent,
          ),
          hintText: widget.hintString,
          hintStyle: TextStyle(color: Colors.grey)
        ),

      ),
    );
  }
}
