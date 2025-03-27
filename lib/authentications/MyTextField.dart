import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final bool isPassword;
  final TextEditingController controller;
  const MyTextField(
      {super.key, required this.isPassword, required this.controller});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isVisable = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: TextStyle(color: Colors.orange),
        cursorColor: Colors.orange,
        controller: widget.controller,
        obscureText: widget.isPassword && !isVisable,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.orange, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.orange, width: 2)),
          label: Text(
              widget.isPassword ? "Enter Your Password" : "Enter Your Email"),
          labelStyle: TextStyle(color: Colors.orange),
          prefixIcon: Icon(
            widget.isPassword ? Icons.password : Icons.email,
            color: Colors.orange,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isVisable ? Icons.visibility : Icons.visibility_off,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      isVisable = !isVisable;
                    });
                  },
                )
              : Icon(Icons.abc, size: 0),
        ));
  }
}
