import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:bhumi_app/Screens/ItemPage/ItemPage.dart';
import 'package:bhumi_app/Service/Date/Income.dart';
import 'package:bhumi_app/Service/Date/Today.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TodayOrder extends StatefulWidget {
  @override
  _TodayOrderState createState() => _TodayOrderState();
}

class _TodayOrderState extends State<TodayOrder> {
  Timestamp start;
  Timestamp end;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    DateTime starttoday = DateTime(now.year,now.month,now.day,0,0,0);
    DateTime endtoday = DateTime(now.year,now.month,now.day,11,59,00);
    start = Timestamp.fromDate(starttoday);
    end = Timestamp.fromDate(endtoday);
    print(start);
  }

  int subtactlocal(int rent ,int extra){
    var num = rent+extra;
    return num;
  }
  
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(start.toDate().toString());
    return Scaffold(
      appBar: BasicAppbar(),
      body: StreamBuilder<List<ItemHistoryModel>>(
          stream: TOdayORDERS(start:start).ITEMHISTORY,

          builder: (context,historysanp){

            if(historysanp.hasData){
              List<ItemHistoryModel> datas = historysanp.data;


              return ListView.builder(
                  itemExtent: height * .18,
                  itemCount: datas.length,
                  itemBuilder: (context,index){
                  ItemHistoryModel localdata = datas[index];
             return   StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('Item').doc(datas[index].prodcutid).snapshots(),
               builder: (context,imageindex){
                  if(imageindex.hasData){
                     return Card(


                      shape:  RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: (){
              return showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: Container(
                          height: height * 0.8,
                          child: Column(
                            children: [


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Customer Name',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].cus_name.toString()),

                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Customer Address',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].cus_address.toString()),

                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Mobile Number',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].cus_number.toString()),

                                  ),
                                ],
                              ),

                              Divider(thickness: 2,color: Colors.black,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Design Id',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].prodcutid.toString()),

                                  ),
                                ],
                              ),
                              Divider(thickness: 3,color: Colors.black,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Advanced',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].advanced.toString()),

                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Rent',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].rentold.toString()),

                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Extra Charge',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text('+ '+datas[index].extracharge.toString()),

                                  ),
                                ],
                              ),
                              Divider(thickness: 1,color: Colors.black,),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(''),

                                  ),
                                  Flexible(

                                    child: Text(subtactlocal(datas[index].rentold,datas[index].extracharge).toString()
                                    ),

                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Discount',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text('- '+datas[index].discount.toString()),

                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),

                              Divider(thickness: 3.0,color: Colors.black,),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Net Amount',style: TextStyle(fontWeight: FontWeight.bold),),

                                  ),
                                  Flexible(
                                    child: Text(datas[index].netrent.toString()),

                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Text('Booking Dates',style: TextStyle(fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:20),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),

                                  ),
                                  child: Container(

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.black
                                          ),
                                          left: BorderSide(
                                              color: Colors.black
                                          ),
                                          top: BorderSide(
                                              color: Colors.black
                                          ),
                                          bottom: BorderSide(
                                              color: Colors.black
                                          ),
                                        )
                                    ),
                                    width: width * .5,
                                    height: height * 0.25,
                                    child: ListView.builder(
                                        itemCount: datas[index].datelist.length,
                                        itemBuilder: (context,dateindex){
                                          return ListTile(
                                            title: Text(datas[index].datelist[dateindex].toString()),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    );
                  }
              );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0)
                              ),
                              width: width * .3,
                              height : height * 0.15,
                              child: Image.network(
                                imageindex.data['Image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20,),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text('ProductId',style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                        Expanded(
                                          child: Text(datas[index].prodcutid,),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text('Customer',style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                        Expanded(
                                          child: Text(datas[index].cus_name,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text('PickupDate',style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                        Expanded(
                                          child: Text(datas[index].datelist[0],),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),


                          ],
                        ),


                      ),

                    );
                  }
                  else{
                    return Text('');
                  }
               }
             );
              });
            }
            else if(historysanp.hasError){
              return Container(
                child: Center(
                  child: Text('Not Booking Found',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
                ),
              );
            }
            else{
              return CircularLoading();
            }
          }
      ),


    );
  }
}
