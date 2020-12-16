

import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TOdayORDERS{
  Timestamp start;


  TOdayORDERS({this.start});
  final CollectionReference _orderreference = FirebaseFirestore.instance.collection('Order');

  List<ItemHistoryModel> itemhistory(QuerySnapshot snapshot) {
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
        orderIDtrack: e.id,


      );
    }).toList();
  }

  Stream<List<ItemHistoryModel>> get ITEMHISTORY {
    try {
      return _orderreference.where(
          'Pickup',isEqualTo: start).snapshots().map(itemhistory);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

}