import 'package:cloud_firestore/cloud_firestore.dart';

class DateEvents{
  String productid;

  Map<DateTime,List<dynamic>> _local = {};
  DateEvents({this.productid});
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('Order');

  Future<Map<DateTime,List<dynamic>>> events()async{
    print('ss');
    await FirebaseFirestore.instance.collection('Order').where('ProductId',isEqualTo: productid).get().then((value){
      final doc =  value.docs;
      for(DocumentSnapshot e in doc){
        for(var i = 0; i< e.data()['BookedDates'].length ;i++){

           int year  = int.parse(e.data()['BookedDates'].toString().substring(1,5));

           int month =int.parse(e.data()['BookedDates'].toString().substring(1,5));
           int day =int.parse(e.data()['BookedDates'].toString().substring(9,11));
            DateTime da  = DateTime(year-month-day);
           _local[da]=['s'];
        }
      }
    });
  return _local;
  }
}