import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/authentications/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var auth = Auth();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
                (route) => false,
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.orange,
            )),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
