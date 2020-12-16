import 'package:bhumi_app/Common/Common.dart';

import 'package:flutter/material.dart';

Widget BasicAppbar(){
  return AppBar(
    title: Text(commonAssets.name),
    backgroundColor: commonAssets.appColors,
  );
}
Widget  BasicAppbarwithButton(Widget button){
   return AppBar(
    title: Text(commonAssets.name),
    backgroundColor: commonAssets.appColors,
    actions: [
      button
    ],
  );

}
Widget  BasicAppbarwithTwoButton(Widget button1,Widget button2){
  return AppBar(
    title: Text(commonAssets.name),
    backgroundColor: commonAssets.appColors,
    actions: [
      button1,
      SizedBox(width: 5,),
      button2
    ],
  );

}
