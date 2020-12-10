import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Screens/Additem/Additem.dart';
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