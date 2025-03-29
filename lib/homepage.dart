import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/authentications/login.dart';
import 'package:daily_nest/favorites.dart';
import 'package:daily_nest/habit/add.dart';
import 'package:daily_nest/habit/collection.dart';
import 'package:daily_nest/habit/recordhabit.dart';
import 'package:daily_nest/habitcard.dart';
import 'package:daily_nest/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  StreamSubscription<User?>? _authSubscription;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

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
    _pageController.dispose();

    _pageController.dispose();
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

  Future<void> _checkAndResetStreaks(List<QueryDocumentSnapshot> habits) async {
    final today = DateTime.now();
    final difference = today.subtract(const Duration(days: 2));

    for (final habit in habits) {
      try {
        final lastPressedDate =
            DateFormat("dd-MM-yyyy").parse(habit['lastpressed']);
        if (lastPressedDate.isBefore(difference)) {
          await habit.reference.update({'streak': 0});
        }
      } catch (e) {
        debugPrint('Error resetting streak: $e');
      }
    }
  }

  Widget _buildHomeContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('habits')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.orange));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "Press the + icon to add habits",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }

        if (snapshot.hasData) {
          _checkAndResetStreaks(snapshot.data!.docs);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          onPressed: _signOut,
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: PageView(
          controller: _pageController,
          children: [_buildHomeContent(), Favoritepage(), Statespage()],
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          physics: ClampingScrollPhysics()),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddHabit()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'States',
          ),
        ],
      ),
    );
  }
}
