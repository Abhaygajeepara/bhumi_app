import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ItemHistory extends StatefulWidget {
  String productId;
  ItemHistory({this.productId});
  @override
  _ItemHistoryState createState() => _ItemHistoryState();
}

class _ItemHistoryState extends State<ItemHistory> {
  List<ItemHistoryModel> _list ;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: BasicAppbar(),
      body: StreamBuilder<List<ItemHistoryModel>>(
        stream: ItemService(itemname: widget.productId).ITEMHISTORY,
        builder: (context,historysanp){
          if(historysanp.hasData){
            List<ItemHistoryModel> datas = historysanp.data;

            return ListView.builder(

                itemCount: datas.length,
                itemBuilder: (context,index){
                  _list = historysanp.data;

                  return Card(

                    
                    child: GestureDetector(
                      onTap: (){
                        return showDialog(
                            context: context,
                              builder: (BuildContext context){
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
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
                                      Divider(thickness: 3.0,color: Colors.black,),
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
                                          child: Container(
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

                              );
                        }
                        );
                      },
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(datas[index].cus_name),

                            Text(datas[index].datelist[0]),
                          ],

                        ),

                      ),
                    ),
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
