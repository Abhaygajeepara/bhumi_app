import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BookingService{

  final CollectionReference _reference = FirebaseFirestore.instance.collection('Order');
  Future bookOrder(String Productid,String c_name,String c_number,String c_add,int advanced,
      int discount,int netamount,List<String> bookeddate,int extracharge,int rent,Timestamp pickup,
      )async{
    try{
      var OrderId =  Uuid().v1();


      return _reference.doc(OrderId).set({

        'ProductId':Productid,
        'Cus_Name':c_name,
        'Cus_Number':c_number,
        'Cus_Add':c_add,
        'Advanced':advanced,
        'Discount':discount,
        'NetAmount':netamount,
        'BookedDates':FieldValue.arrayUnion(bookeddate),
        'Date':FieldValue.serverTimestamp(),
        'ExtraCharge':extracharge,
        'RentOld':rent ,
        'CompleteOrder':false,
        'Pickup':pickup
      });
    }
    catch(e){
      return null;
    }
  }

 Future completeOrder(String item,bool ordercomp){
   _reference.doc(item).update({
     'CompleteOrder':ordercomp,
   });
 }
  Future OrderIdDelete(String item,){
    _reference.doc(item).delete();
  }
}