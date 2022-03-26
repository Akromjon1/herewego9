
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hererwego/pages/signup_page.dart';
import 'package:hererwego/services/auth_services.dart';
import 'package:hererwego/services/pref_services.dart';
import 'package:hererwego/services/utils.dart';

import 'home_page.dart';
class SignInPage extends StatefulWidget {
  static final String id = 'signin_page';
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  var isLoading = false;


  _doSignIn() {
    String email = emailcontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();
    if(email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Check your email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    obscureText: true,
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: FlatButton(
                      onPressed: () {
                        _doSignIn();
                      },
                      color: Colors.deepOrange,
                      child: Text("Sign in", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPage.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Don`t have an account?"),
                          SizedBox(width: 10,),
                          Text("Sign up"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            isLoading ?
            Center(
              child: CircularProgressIndicator(),
            ) : SizedBox.shrink(),
          ],
        )
    );
  }
}