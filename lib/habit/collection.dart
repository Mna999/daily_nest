import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Collections {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Habits collection operations
  static CollectionReference get habits => _firestore.collection("habits");

  static Future<List<QueryDocumentSnapshot>> getHabits() async {
    final user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot =
          await habits.where('uid', isEqualTo: user.uid).get();

      return querySnapshot.docs;
    }
    return [];
  }

  static Future<void> addHabit(String name, String category) async {
    final user = _auth.currentUser;
    if (user != null) {
      await habits.add({
        "name": name,
        "streak": 0,
        "isFav": false,
        "lastpressed": DateFormat('dd-MM-yyyy').format(DateTime.now()),
        "category": category,
        "uid": user.uid,
      });
    }
  }

  static Future<void> updateHabit(
      String docId, String newName, String newCategory) async {
    await habits.doc(docId).update({"name": newName, "category": newCategory});
  }

  static Future<void> updateHabitStreak(String docId, int newStreak) async {
    final formatter = DateFormat('dd-MM-yyyy');
    await habits.doc(docId).update({
      "streak": newStreak,
      "lastpressed": formatter.format(DateTime.now()),
    });
  }

  static Future<void> toggleFavorite(String docId, bool isFav) async {
    await habits.doc(docId).update({"isFav": !isFav});
  }

  static Future<void> deleteHabit(String docId) async {
    await habits.doc(docId).delete();
  }
}
