import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService{

  final CollectionReference _reference = FirebaseFirestore.instance.collection('Order');
  Future bookOrder(int OrderNumber,String Productid,String c_name,String c_number,String c_add,int advanced,int discount,int netamount,List<String> date)async{
    try{
      int newnumber = OrderNumber +1;
      String docname = Productid + newnumber.toString();
      return _reference.doc(docname).set({
        'OrderNumber':newnumber,
        'ProductId':Productid,
        'Cus_Name':c_name,
        'Cus_Number':c_number,
        'Cus_Add':c_add,
        'Advanced':advanced,
        'Discount':discount,
        'NetAmount':ne

      });
    }
    catch(e){
      return null;
    }
  }
}