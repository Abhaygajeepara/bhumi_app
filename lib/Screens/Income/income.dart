import 'dart:math';

import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:bhumi_app/Service/Date/Income.dart';
import 'package:bhumi_app/Service/Date/Numberofday.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Income extends StatefulWidget {
  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  List<int> monthlist = [1,2,3,4,5,6,7,8,9,10,11,12];
  final _formkey = GlobalKey<FormState>();
  Timestamp start;
  Timestamp end;
  bool ismonth = true;
  DateTime now = DateTime.now();
  int currentmonth;
  int currentyear;
  bool year = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     currentmonth = now.month;
     currentyear = now.year;

  }
  int subtactlocal(int rent ,int extra){
    var num = rent+extra;
    return num;
  }
  Future income(int month ,int year)async{


    if(ismonth)
      {



       setState(() {
         int lastday =  NumberOfDay().totalDays(year, month);
         start =  Timestamp.fromDate(DateTime(year,month,0,0,0,0));
         end =  Timestamp.fromDate(DateTime(year,month,lastday,23,59,59));
       });

      }
    else{
      DateTime now = DateTime.now();



     setState(() {
       int lastday =  NumberOfDay().totalDays(now.year, now.month);
       start =  Timestamp.fromDate(DateTime(year,1,1));
       end =  Timestamp.fromDate(DateTime(year,12,lastday,23,59,59));
     });


    }


  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    income(currentmonth,currentyear);

    return Scaffold(
      appBar: BasicAppbar(),
      body: StreamBuilder<List<ItemHistoryModel>>(
              stream: ProfitAndTodayOrder(start:start,end: end).ITEMHISTORY,

              builder: (context,historysanp){
                int profit = 0 ;
                if(historysanp.hasData){
                  List<ItemHistoryModel> datas = historysanp.data;
                    int lengthdoc = datas.length;

                    for(var i =0;i<lengthdoc;i++){
                      profit =  profit + datas[i].netrent;

                    }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formkey,
                          autovalidate: true,
                          child: Row(
                            children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: inputdecoration,
                                value: currentmonth,
                              items: monthlist.map((e) {
                                return new DropdownMenuItem<int>(
                                  value: e,
                                  child: Text(e.toString()),
                                );
                              }).toList(), onChanged: (val) {
                                    setState(() {
                                  currentmonth =val;
                                    });
                            },
                            ),

                          ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: TextFormField(
                                  decoration: inputdecoration,
                                  keyboardType: TextInputType.number,
                                  initialValue: now.year.toString(),
                                  validator: numbervalidtion,
                                  onChanged: (val){
                                    if(int.tryParse(val) != null){
                                  setState(() {
                                    currentyear =int.parse(val);
                                  });
                                    }


                                  },
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: ismonth,
                                      onChanged: (val){
                                        setState(() {
                                          ismonth = !ismonth;
                                        });

                                      },
                                      activeColor: commonAssets.appbuttonColor,
                                      checkColor: commonAssets.commonbuttontextcolor,

                                    ),
                                    Text('Month')
                                  ],
                                )

                              )

                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Net Profit',style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),),
                            Text(profit.toString(),style:TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            ),)
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(

                            itemCount: datas.length,
                            itemBuilder: (context,index){





                              Timestamp bookingstamp = datas[index].bookingdate;
                                DateTime bookeddate = bookingstamp.toDate();
                              return Card(


                                child: GestureDetector(
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
                                                          child: Text('DesignId',style: TextStyle(fontWeight: FontWeight.bold),),

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
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: Text(datas[index].netrent.toString()),),

                                        Flexible(child: Text(bookeddate.toString().substring(0,11))),
                                      ],

                                    ),

                                  ),
                                ),
                              );
                            }),
                      )
                    ],

                  );
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


  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]{4}';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return null;
    } else {
      return null;
    }
  }
}
