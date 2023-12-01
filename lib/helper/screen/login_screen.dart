import 'package:ev_admin/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSecurePassword = true;
  //text edit controllers
  TextEditingController adminEmailCOntroller = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Login",
          style: Helper.pageTitle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            child: Column(
              children: [
                //login animation
                Center(
                  child: Container(
                    child: Lottie.asset(
                      "assets/login.json",
                      height: 200,
                      width: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //email text field
                Container(
                  height: 50,
                  width: 400,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(9)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 13),
                    child: TextFormField(
                      //controller
                      controller: adminEmailCOntroller,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.green,
                          ),
                          border: InputBorder.none,
                          hintText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                //password textfield
                Container(
                  height: 50,
                  width: 400,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(9)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                    child: TextFormField(
                      //controller
                      controller: adminPasswordController,
                      obscureText: _isSecurePassword,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.key,
                            color: Colors.green,
                          ),
                          suffixIcon: togglePassword(),
                          hintText: "Password"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                //elevated button for login
                Container(
                  height: 50,
                  width: 400.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      //

                      var loginEmail = adminEmailCOntroller.text.trim();
                      var loginPassword = adminPasswordController.text.trim();
                      //login function
                      try {
                        final User? firebaseUser = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: loginEmail, password: loginPassword))
                            .user;

                        Navigator.of(context).pop();
                        //navigate to home screen if the condition met
                        if (firebaseUser != null) {
                          Get.to(() => const HomeScreen());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Username and Password not valid !!')));
                          //print("Check Email and password");
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Sorry, Something went wrong!!')));
                      }

                      try {} on FirebaseAuthException catch (e) {
                        print("Error $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Background color
                      onPrimary: Colors.grey, // Text color
                      elevation: 4, // Button elevation
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Button border radius
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: Helper.pageTitle,
                    ),
                  ),
                ),

                //const Spacer(),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //toogle icon for passowrd
  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(
              (Icons.visibility),
              size: 20,
            )
          : const Icon(
              Icons.visibility_off,
              size: 20,
            ),
      color: Colors.green,
    );
  }
}
