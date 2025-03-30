import 'package:flutter/material.dart';

class Categortdropdown extends StatefulWidget {
  final Function(String?) updateParent;
  final String startingCategory;
  Categortdropdown(
      {super.key, required this.updateParent, required this.startingCategory});

  @override
  State<Categortdropdown> createState() => _CategortdropdownState();
}

class _CategortdropdownState extends State<Categortdropdown> {
  String? selectedItem;
  List<String> data = ['Sports', 'Work', 'Study', 'Life', 'Others'];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < data.length; i++) {
      if (widget.startingCategory == data[i]) {
        selectedItem = data[i];
      }
    }
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        value: selectedItem,
        icon: Container(
          width: size.width * 0.56,
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down,
            color: Colors.orange,
            size: 30,
          ),
        ),
        iconSize: 24,
        elevation: 4,
        style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        underline: Container(),
        items: data.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedItem = value;
          });
          widget.updateParent(selectedItem);
        },
      ),
    );
  }
}
