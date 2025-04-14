import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_nest/Alert.dart';
import 'package:daily_nest/habit/collection.dart';
import 'package:daily_nest/habit/recordcard.dart';
import 'package:daily_nest/homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Recordhabit extends StatelessWidget {
  final String habitId;

  const Recordhabit({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/icons8-easter-eggs-100.png",
              scale: 3,
            ),
            const SizedBox(width: 3),
            const Text(
              "Daily",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Nest",
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .doc(habitId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Habit not found'));
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.9,
                  child: Recordcard(habitData: snapshot.data!),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () async {
                        final formatter = DateFormat('dd-MM-yyyy');

                        if (snapshot.data!['lastpressed'] ==
                            formatter.format(DateTime.now())) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Habit has already been nested for the day"),
                            backgroundColor: Colors.orange,
                          ));
                        } else {
                          Collections.updateHabitStreak(
                              snapshot.data!.id, snapshot.data!['streak'] + 1);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Habit nested successfully"),
                            backgroundColor: Colors.orange,
                          ));
                        }
                      },
                      child: Text("Nest Habit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
