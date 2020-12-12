import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class AdditemService{

  final CollectionReference _itemrefrence = FirebaseFirestore.instance.collection('Item');

  Future additem(String productname,String productid,int   rent,File image) async{

    String url ;
    try{
      final existdoc = await _itemrefrence.doc(productid).get();
      print(existdoc.exists);
      if(existdoc.exists == false){
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref('/').child('/Images/$productname') ;
        firebase_storage.UploadTask uploadTask = ref.putFile(image);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value){

              url = value;
              _itemrefrence.doc(productid).set({
                'Product':productname,
                'ProductId':productid,
                'Rent':rent,
                'Image':url,
                'active':true,

              });

            }
        );


      }
      else{
        return "exist";
      }




    }
    catch(e){
      print(e.toString());
      return true;
    }
  }
}
