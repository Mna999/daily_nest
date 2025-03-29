import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/authentications/login.dart';
import 'package:daily_nest/habit/add.dart';
import 'package:daily_nest/habit/collection.dart';
import 'package:daily_nest/habit/recordhabit.dart';
import 'package:daily_nest/habitcard.dart';
import 'package:daily_nest/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favoritepage extends StatefulWidget {
  const Favoritepage({super.key});

  @override
  State<Favoritepage> createState() => _FavoritepageState();
}

class _FavoritepageState extends State<Favoritepage> {
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _signOut() async {
    try {
      await Auth().signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view favorites')),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .where('uid', isEqualTo: userId)
            .where('isFav', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Debug output
          if (snapshot.hasData) {
            debugPrint('Fetched ${snapshot.data!.docs.length} favorite habits');
            for (var doc in snapshot.data!.docs) {
              debugPrint(
                  'Favorite habit: ${doc['name']} (isFav: ${doc['isFav']})');
            }
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "There are no favorite habits",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Recordhabit(habitId: snapshot.data!.docs[index].id),
                  ),
                );
              },
              child: HabitCard(habitId: snapshot.data!.docs[index].id),
            ),
          );
        },
      ),
    );
  }
}
