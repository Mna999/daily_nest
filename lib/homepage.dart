import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/authentications/login.dart';
import 'package:daily_nest/habit/add.dart';
import 'package:daily_nest/habit/collection.dart';
import 'package:daily_nest/habitcard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = false;
  List<QueryDocumentSnapshot> data = [];
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    getData();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
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

  getData() async {
    print("Fetching data...");
    setState(() {
      isLoading = true;
    });

    final habits = await Collections.getHabits();

    if (mounted) {
      setState(() {
        data = habits;
        isLoading = false;
      });
    }
    print("Data fetched: ${data.length} items");
  }

  Future<void> _signOut() async {
    try {
      await Auth().signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddHabit(),
              )).then((_) => getData());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/icons8-easter-eggs-100.png",
              scale: 3,
            ),
            SizedBox(width: 3),
            Text(
              "Daily",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Nest",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )
          ],
        ),
        leading: IconButton(
          onPressed: _signOut,
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: data.isEmpty
          ? Center(
              child: Text(
                "Press the + icon to add habits",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: data.length,
                  itemBuilder: (context, index) => HabitCard(
                    habitData: data[index],
                  ),
                ),
    );
  }
}