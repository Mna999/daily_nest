import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Alert extends StatefulWidget {
  final String Message;
  Alert({
    super.key,
    required this.Message,
  });

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Alert",
        style: TextStyle(color: Colors.orange),
      ),
      content: Text(widget.Message, style: TextStyle(color: Colors.orange)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK", style: TextStyle(color: Colors.orange)))
      ],
    );
  }
}
