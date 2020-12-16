
import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Service/Auth/LoginAuto.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
    String error = '';
   String email ;
   String password ;
    bool _vision = true;
   final _loginformkey = GlobalKey<FormState>();

  @override
  void _visibility(){
    setState(() {
      print(_vision);
      _vision = ! _vision;
    });
  }
  Widget build(BuildContext context) {
// print('$error');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  commonAssets.name.toString(),
                  style: TextStyle(
                    color:Colors.blue,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500

                  ),
                ),

                  SizedBox(height: 20,),
                  Text(
                      'Log In',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:30.0,
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                SizedBox(height: 10,),
                Text(
                  error.toString(),
                  style: TextStyle(
                    color: Colors.red,


                  ),
                ),
                SizedBox(height: 20,),
                Form(
                  key: _loginformkey,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: width * 0.10),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: inputdecoration.copyWith(labelText: 'Email'),
                          validator: (val) => val.isEmpty ?'Enter The Correct Email':null,
                          onChanged: (val)=> email =val,
                        ),
                        SizedBox(height:20,),
                        TextFormField(
                          obscureText: _vision,
                          decoration: inputdecoration.copyWith(labelText: 'Password',suffixIcon: IconButton(
                            onPressed:_visibility,
                            icon:_vision == true ? Icon(Icons.visibility_off,color:  Colors.black,):Icon(Icons.visibility,color: Colors.black),),
                            errorStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,


                            ),),
                          validator: (val) => val.isEmpty ?'Enter The Password':null,
                          onChanged: (val)=> password =val,

                        ),
                        SizedBox(height: 20,),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.15,vertical: height * 0.02),
                          shape: StadiumBorder(),
                          color: commonAssets.appbuttonColor,
                          onPressed: ()async{
                          if(_loginformkey.currentState.validate()){
                            dynamic result = await  LogInAndSignIn().autoLogin(email,password);
                            print(result);
                            if(result == 'invalid-email'){
                              setState(() {
                                error = 'Invalid Email';
                              });

                            }
                            else if(result == 'wrong-password'){
                              setState(() {
                                error = 'Wrong Password';
                              });

                            } else if(result == 'user-not-found'){
                              setState(() {
                                error = 'Email Is Not Exist';
                              });

                            }

                          }
                          else{
                            return null;
                          }
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),

                      ],
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
    ),
      )
    );
  }
}
