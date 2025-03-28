import 'package:flutter/material.dart';

class EditHabit extends StatefulWidget {
  final String oldName;
  final docId;
  EditHabit({super.key, required this.oldName, this.docId});

  @override
  State<EditHabit> createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
