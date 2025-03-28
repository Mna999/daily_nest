import 'package:daily_nest/Alert.dart';
import 'package:daily_nest/authentications/MyTextField.dart';
import 'package:daily_nest/authentications/auth.dart';
import 'package:daily_nest/authentications/signup.dart';
import 'package:daily_nest/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                      SizedBox(height: 40),
                      Image.asset(
                        "assets/images/icons8-login-50.png",
                        width: size.width * 0.5,
                        height: size.height * 0.2,
                      ),
                      SizedBox(height: 30),
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
                      SizedBox(height: 30),
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
                      SizedBox(height: 10),
                      SizedBox(
                          width: size.width * 0.8,
                          child: MyTextField(
                              message: "Enter you email",
                              isPassword: false,
                              controller: email)),
                      SizedBox(height: 20),
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
                      SizedBox(height: 10),
                      SizedBox(
                          width: size.width * 0.8,
                          child: MyTextField(
                              message: "Enter your password",
                              isPassword: true,
                              controller: password)),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          if (email.text.trim().isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    Alert(Message: "Please enter your email."));
                          } else {
                            auth.sendPasswordResetEmail(email.text.trim());
                            showDialog(
                                context: context,
                                builder: (context) => Alert(
                                    Message:
                                        "An email was sent to reset your password."));
                          }
                        },
                        child: SizedBox(
                          width: size.width * 0.9,
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                          width: size.width * 0.5,
                          height: size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (email.text.trim().isEmpty ||
                                  password.text.trim().isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) => Alert(
                                        Message:
                                            "Please enter both email and password"));
                                return;
                              }

                              try {
                                setState(() => isLoading = true);
                                final user =
                                    await auth.signInWithEmailAndPassword(
                                  email.text.trim(),
                                  password.text.trim(),
                                );

                                if (user != null) {
                                  if (!user.emailVerified) {
                                    await user.sendEmailVerification();
                                    showDialog(
                                        context: context,
                                        builder: (context) => Alert(
                                            Message:
                                                "Verification email sent. Please check your inbox."));
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Homepage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) => Alert(
                                        Message: auth.handleAuthException(e)));
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) => Alert(
                                        Message:
                                            "An error occurred. Please try again."));
                              } finally {
                                if (mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            },
                            child: Text("Login"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          )),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have An Account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 7),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signup(),
                                  ));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Or LogIn with",
                        style: TextStyle(color: Colors.white),
                      ),
                      Center(
                          child: IconButton(
                              onPressed: () async {
                                try {
                                  setState(() => isLoading = true);
                                  final user = await auth.signInWithGoogle();
                                  if (user != null) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Homepage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Alert(
                                          Message:
                                              "Google sign-in failed. Please try again."));
                                } finally {
                                  if (mounted) {
                                    setState(() => isLoading = false);
                                  }
                                }
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
