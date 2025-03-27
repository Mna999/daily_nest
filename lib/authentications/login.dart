import 'package:daily_nest/authentications/MyTextField.dart';
import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Image.asset(
                        "assets/images/icons8-login-50.png",
                        width: size.width * 0.5,
                        height: size.height * 0.2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Text(
                          "LogIn",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: size.width * 0.8,
                          child: MyTextField(
                              isPassword: false, controller: email)),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: size.width * 0.8,
                          child: MyTextField(
                              isPassword: true, controller: password)),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: size.width * 0.5,
                          height: size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate input first
                              if (email.text.isEmpty || password.text.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error",
                                        style: TextStyle(color: Colors.orange)),
                                    content: Text(
                                        "Please enter both email and password",
                                        style: TextStyle(color: Colors.orange)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              try {
                                setState(() => isLoading = true);
                                final user =
                                    await auth.signInWithEmailAndPassword(
                                  email.text.trim(),
                                  password.text.trim(),
                                );

                                setState(() => isLoading = false);

                                if (user != null) {
                                  if (!auth.isEmailVerified) {
                                    await auth.sendEmailVerification();
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Verify Email",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                        content: Text(
                                            "Verification email sent. Please check your inbox.",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("OK",
                                                style: TextStyle(
                                                    color: Colors.orange)),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Homepage()),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() => isLoading = false);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Login Failed",
                                        style: TextStyle(color: Colors.orange)),
                                    content: Text(auth.handleAuthException(e),
                                        style: TextStyle(color: Colors.orange)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (e) {
                                setState(() => isLoading = false);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error",
                                        style: TextStyle(color: Colors.orange)),
                                    content: Text(
                                        "An unexpected error occurred. Please try again.",
                                        style: TextStyle(color: Colors.orange)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text("Login"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ))
                    ],
                  ),
                ),
              ));
  }
}
