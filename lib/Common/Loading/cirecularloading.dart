
import 'package:bhumi_app/Common/Common.dart';
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            semanticsLabel:'Loading' ,
            valueColor:AlwaysStoppedAnimation<Color>(commonAssets.circularLoading),
        backgroundColor: commonAssets.circularLoadingbackgroud,

        ));
  }
}
