import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Recordcard extends StatelessWidget {
  final DocumentSnapshot habitData;

  const Recordcard({super.key, required this.habitData});

  @override
  Widget build(BuildContext context) {
    final isFav = habitData['isFav'] as bool? ?? false;
    final name = habitData['name'] as String? ?? 'Unnamed Habit';
    final streak = habitData['streak'] as int? ?? 0;
    final lastPressed = habitData['lastpressed'] as String? ?? 'Never';
    final category = habitData['category'] as String? ?? 'Sports';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 30,
                ),
                const SizedBox(width: 3),
                Text(
                  "Current Streak: $streak days",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.orange,
                  size: 30,
                ),
                const SizedBox(width: 3),
                Text(
                  "Last Recorded: $lastPressed",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  isFav ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFav ? Colors.red : Colors.grey,
                  size: 30,
                ),
                const SizedBox(width: 3),
                Text(
                  isFav ? "Favorite" : "Not Favorite",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.category,
                  color: Colors.orange,
                  size: 30,
                ),
                const SizedBox(width: 3),
                Text(
                  "Category: $category",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
