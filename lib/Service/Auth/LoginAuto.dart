
import 'package:bhumi_app/Model/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LogInAndSignIn {
final FirebaseAuth _auth = FirebaseAuth.instance;

  Future autoLogin(String email,String password)async{

    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email:email, password: password);
      print(result.user.email);

      return  _personalinfo(result.user);;
    }
    catch(e){
      print(e.code);
      if(e.code == 'invalid-email'){
        return 'invalid-email';
      }
      else if(e.code == 'wrong-password'){

        return 'wrong-password';
      } else if(e.code == 'user-not-found'){
        return 'user-not-found';
      }
      else{
        return print(e.toString());
      }

      print(e.toString());
    }
  }


Future signouts()async{
    try{
      await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
}

UserDATA _personalinfo (User user){
    try{
      return user != null?UserDATA(userid: user.uid,email: user.email):null;
    }
    catch(e){
      print(e.toString());
    }
}
Stream<UserDATA> get USERDATA{
    return _auth.authStateChanges().map(_personalinfo);
}
}