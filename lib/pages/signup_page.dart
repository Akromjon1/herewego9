import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hererwego/pages/signin_page.dart';
import 'package:hererwego/services/auth_services.dart';
import 'package:hererwego/services/pref_services.dart';
import 'package:hererwego/services/utils.dart';


import 'home_page.dart';
class SignUpPage extends StatefulWidget {
  static final String id = "signup_page";
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var fullnamecontroller = TextEditingController();

  _dosign_up(){
    String name=fullnamecontroller.text.toString().trim();
    String email=emailcontroller.text.toString().trim();
    String password=passwordcontroller.text.toString().trim();
    if(name.isEmpty||email.isEmpty|| password.isEmpty)return;
    setState(() {
      isLoading=true;
    });
    AuthService.SignUpUser(context, name, email, password).then((firebaseUser) =>
    {
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
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: fullnamecontroller,
                    decoration: InputDecoration(
                      hintText: "Fullname",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    obscureText: true,
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                        hintText: "Password"
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: (){
                        _dosign_up();
                      },
                      color: Colors.deepOrange,
                      child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Already have an account?",style: TextStyle(color: Colors.black,fontSize: 16),),
                      SizedBox(width: 8,),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, SignInPage.id);
                          },
                          child: Text("Sign In",style: TextStyle(color: Colors.blue,fontSize: 16),)),
                    ],
                  ),
                ],
              ),
            ),
            isLoading==true?
            Center(
              child: CircularProgressIndicator(),
            ):
            SizedBox.shrink(),
          ],
        )
    );
  }
}