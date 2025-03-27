import 'package:daily_nest/Alert.dart';
import 'package:daily_nest/authentications/MyTextField.dart';
import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/authentications/login.dart';
import 'package:daily_nest/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  var user;
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
                          "SignUp",
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
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          width: size.width * 0.8,
                          child: MyTextField(
                              isPassword: true, controller: confirmPassword)),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: size.width * 0.5,
                          height: size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (email.text.trim().isEmpty ||
                                  password.text.trim().isEmpty ||
                                  confirmPassword.text.trim().isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) => Alert(
                                        Message:
                                            "Please enter both email and password"));
                                return;
                              } else if (password.text.trim() !=
                                  confirmPassword.text.trim()) {
                                showDialog(
                                    context: context,
                                    builder: (context) => Alert(
                                        Message:
                                            "Both password must be the same"));
                                return;
                              }

                              try {
                                setState(() => isLoading = true);
                                user =
                                    await auth.createUserWithEmailAndPassword(
                                  email.text.trim(),
                                  password.text.trim(),
                                );

                                setState(() => isLoading = false);

                                if (user != null) {
                                  if (!auth.isEmailVerified) {
                                    await auth.sendEmailVerification();
                                    showDialog(
                                        context: context,
                                        builder: (context) => Alert(
                                            Message:
                                                "Verification email sent. Please check your inbox."));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
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
                                    builder: (context) => Alert(
                                        Message: auth.handleAuthException(e)));
                              } catch (e) {
                                if (mounted) {
                                  setState(() => isLoading = false);

                                  showDialog(
                                      context: context,
                                      builder: (context) => Alert(
                                          Message:
                                              "An unexpected error occurred. Please try again."));
                                }
                              }
                            },
                            child: Text("Sign Up"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Alread Have An Acoount?",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ));
                            },
                            child: Text(
                              "LogIn",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Or LogIn with",
                        style: TextStyle(color: Colors.white),
                      ),
                      Center(
                          child: IconButton(
                              onPressed: () async {
                                isLoading = true;
                                setState(() {});
                                user = await auth.signInWithGoogle();
                                isLoading = false;
                                setState(() {});
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Homepage(),
                                    ));
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.orange,
                                size: 30,
                              ))),
                    ],
                  ),
                ),
              ));
  }
}
