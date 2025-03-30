import 'package:daily_nest/Alert.dart';
import 'package:daily_nest/authentications/MyTextField.dart';
import 'package:daily_nest/habit/categortDropDown.dart';
import 'package:daily_nest/habit/collection.dart';
import 'package:daily_nest/homepage.dart';
import 'package:flutter/material.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  TextEditingController name = TextEditingController();
  String selectedValue = "Sports";
  updateParent(String newValue) {
    setState(() {
      selectedValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.orange,
            )),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/icons8-easter-eggs-100.png",
              scale: 3,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              "Add",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Habit",
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Text(
                  "Name",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: MyTextField(
                    isPassword: false,
                    controller: name,
                    message: "Enter the name of the habit"),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Text(
                  "Category",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Categortdropdown(
                    startingCategory: 'Sports',
                    updateParent: (newValue) => updateParent(newValue!)),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (name.text.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              Alert(Message: "Enter the name of the habit"),
                        );
                      } else {
                        Collections.addHabit(name.text, selectedValue);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homepage(),
                            ));
                      }
                    },
                    child: Text("ADD"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
