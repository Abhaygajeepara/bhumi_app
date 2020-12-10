import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService{
String itemname ;
ItemService({this.itemname});
final CollectionReference _reference = FirebaseFirestore.instance.collection('Item');



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
      ordernumber:snapshot.data()['OrderNumber']

  ):null;
}

Stream<ItemDetails> get ItemDETAILS{
    return _reference.doc(itemname).snapshots().map((itemDetails));
}

Future deleteItem()async{
  try{return await  _reference.doc(itemname).delete();}catch(e){print(e.toString());}

}

}