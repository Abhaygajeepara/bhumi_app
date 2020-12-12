import 'dart:io';

import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ItemService{
String itemname ;
ItemService({this.itemname});
final CollectionReference _reference = FirebaseFirestore.instance.collection('Item');
final CollectionReference _orderreference = FirebaseFirestore.instance.collection('Order');



Stream<QuerySnapshot> get ITEMDATA{
  return _reference.where('active',isEqualTo: true).snapshots();
}

ItemDetails itemDetails(DocumentSnapshot snapshot){
  return snapshot != null ?
  ItemDetails(
    productname: snapshot.data()['Product'],
    productid: snapshot.data()['ProductId'],
    rent: snapshot.data()['Rent'],
    url: snapshot.data()['Image'],
    active: snapshot.data()['active'],


  ):null;
}

Stream<ItemDetails> get ItemDETAILS{
    return _reference.doc(itemname).snapshots().map((itemDetails));
}

Future deleteItem()async{
  try{return await  _reference.doc(itemname).delete();}catch(e){print(e.toString());}

}
Future disableItem()async{
  //try{return await  _reference.doc(itemname).delete();}catch(e){print(e.toString());}

}
Future updateitem(String url,int rent,String productname,File image)async{
  try{
    if(image == null){
      _reference.doc(itemname).update({

        'Rent':rent,
        'Image':url,


      });
    }
    else{
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/').child('/Images/$productname') ;
      firebase_storage.UploadTask uploadTask = ref.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (value){

            url = value;
            _reference.doc(itemname).update({

              'Rent':rent,
              'Image':url,
              'active':true,

            });

          }
      );
    }
  }
  catch(e){
    print(e.toString());
  }
}



List<ItemHistoryModel> _itemhistory(QuerySnapshot snapshot){
  return snapshot.docs.map((e){
    return ItemHistoryModel(
      cus_name: e.data()['Cus_Name'],
      cus_number: e.data()['Cus_Number'],
      cus_address: e.data()['Cus_Add'],
      prodcutid: e.data()['ProductId'],
      advanced: e.data()['Advanced'],
      discount: e.data()['Discount'],
      netrent: e.data()['NetAmount'],
      datelist: List.from(e.data()['BookedDates']),
      rentold:e.data()['RentOld'],
      extracharge:e.data()['ExtraCharge']

    );
  }).toList();
}
Stream<List<ItemHistoryModel>> get ITEMHISTORY{
  try{
    return _orderreference.orderBy('Date',descending: true).where('ProductId',isEqualTo: itemname).snapshots().map(_itemhistory);
  }
  catch(e){
    print(e.toString());
    return null;

  }
}

}