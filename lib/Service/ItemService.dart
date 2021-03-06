import 'dart:io';

import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ItemService {
  String itemname;

  ItemService({this.itemname});

  final CollectionReference _reference = FirebaseFirestore.instance.collection(
      'Item');
  final CollectionReference _orderreference = FirebaseFirestore.instance
      .collection('Order');


  Stream<List<ItemDetails>> get ITEMDATA {
    return _reference.where('active', isEqualTo: true).snapshots().map((_itemDetails));
  }
  Stream<List<ItemDetails>> get ITEMDATADIASBLE {
    return _reference.where('active', isEqualTo: false).snapshots().map((_itemDetails));
  }

  List<ItemDetails> _itemDetails(QuerySnapshot snapshotdoc){
    return snapshotdoc.docs.map((e){
     return ItemDetails(
        productname: e.data()['Product'],
        productid: e.data()['ProductId'],
        rent: e.data()['Rent'],
        url: e.data()['Image'],
        active: e.data()['active'],

      );

    }).toList();

  }

  ItemDetails singleitemDetails(DocumentSnapshot snapshot) {
    return snapshot != null ?
    ItemDetails(
      productname: snapshot.data()['Product'],
      productid: snapshot.data()['ProductId'],
      rent: snapshot.data()['Rent'],
      url: snapshot.data()['Image'],
      active: snapshot.data()['active'],
        description: List.from(snapshot.data()['Description'])

    ) : null;
  }

  Stream<ItemDetails> get ItemDETAILS {
    return _reference.doc(itemname).snapshots().map((singleitemDetails));
  }

  Future deleteItem() async {
    try {
      return await _reference.doc(itemname).delete();
    } catch (e) {
      print(e.toString());
    }
  }



  Future updateitem(String url, int rent, String productname,
      File image) async {
    try {
      if (image == null) {
        _reference.doc(itemname).update({

          'Rent': rent,
          'Image': url,



        });
      }
      else {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance
            .ref('/').child('/Images/$productname');
        firebase_storage.UploadTask uploadTask = ref.putFile(image);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value) {
              url = value;
              _reference.doc(itemname).update({

                'Rent': rent,
                'Image': url,


              });
            }
        );
      }
    }
    catch (e) {
      print(e.toString());
    }
  }

  Future activeitem(bool active) {
    try {
      _reference.doc(itemname).update({
        'active':!active
      });
    }
    catch (e) {
      print(e.toString());
    }
  }



  List<ItemHistoryModel> _itemhistory(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return ItemHistoryModel(
          cus_name: e.data()['Cus_Name'],
          cus_number: e.data()['Cus_Number'],
          cus_address: e.data()['Cus_Add'],
          prodcutid: e.data()['ProductId'],
          advanced: e.data()['Advanced'],
          discount: e.data()['Discount'],
          netrent: e.data()['NetAmount'],
          datelist: List.from(e.data()['BookedDates']),
          rentold: e.data()['RentOld'],
          extracharge: e.data()['ExtraCharge'],
          bookingdate:e.data()['Date'],
          compeleteorder:e.data()['CompleteOrder'],
          orderIDtrack:e.id

      );
    }).toList();
  }

  Stream<List<ItemHistoryModel>> get ITEMHISTORY {
    try {
      return _orderreference.orderBy('Date', descending: true).where(
          'ProductId', isEqualTo: itemname).snapshots().map(_itemhistory);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }
  Stream<List<ItemHistoryModel>> get HISTORY {
    try {
      return _orderreference.orderBy('Date', descending: true).snapshots().map(_itemhistory);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addDescriptionElement(String element)async {
    await FirebaseFirestore.instance.collection('Item').doc(itemname).update({
      'Description': FieldValue.arrayUnion([element]),
    });
  }
  Future deleteDescriptionElement(String element)async{
    await FirebaseFirestore.instance.collection('Item').doc(itemname).update({
      'Description':FieldValue.arrayRemove([element]),
    });
  }

}