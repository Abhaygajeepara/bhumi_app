import 'package:bhumi_app/Screens/Auth/Login.dart';
import 'package:bhumi_app/Screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        if(!snapshot.hasData || snapshot.data == null)
        {
          return LogIn();
        }
        else{
          return Home();
        }
      },
    );
  }
}
