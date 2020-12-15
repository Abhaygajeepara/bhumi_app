import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Screens/ItemPage/Imageview.dart';
import 'package:bhumi_app/Screens/ItemPage/ItemHistory.dart';
import 'package:bhumi_app/Screens/ItemPage/Update/ItemUpdate.dart';
import 'package:bhumi_app/Screens/ItemPage/booking.dart';
import 'package:bhumi_app/Service/AdditemService.dart';
import 'package:bhumi_app/Service/Date/Dataevents.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:table_calendar/table_calendar.dart';

class ItemPage extends StatefulWidget {
  String item;
  ItemPage({this.item});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  CalendarController _calendarController;
  Map<DateTime,List<dynamic>> _events;
  @override
  void initState() {
    // TODO: implement initState5
    super.initState();
    _calendarController = CalendarController();
    _events = {};

  }
  Future<Map<DateTime,List<dynamic>>> getdate()async{

    await FirebaseFirestore.instance.collection('Order').where('ProductId',isEqualTo: widget.item).get().then((value){
      final doc =  value.docs;
      for(DocumentSnapshot e in doc){
        for(var i = 0; i< e.data()['BookedDates'].length ;i++){
          DateTime convert = DateTime.parse(e.data()['BookedDates'][i]);
          setState(() {
            _events[convert]=[Colors.green];
          });
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    getdate();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if(widget.item == null || widget.item == ''){
      return Scaffold(
        appBar: BasicAppbar(),
        body: Center(
          child: RaisedButton(
            onPressed: (){
              return Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ),
      );
    }
    else{
      return Scaffold(
        appBar: BasicAppbarwithButton(IconButton(
          color: Colors.white,
          onPressed: ()async{

            return showDialog(context: context,
                builder:(BuildContext context){
                    return AlertDialog(
                      title: Text('Are You Sure'),
                      content: Text('You Want To Delete ('+widget.item + ") Item ?"),

                      actions: [
                        FlatButton(

                          onPressed: ()async{
                            await ItemService(itemname: widget.item).deleteItem();
                            Navigator.pop(context);
                            return   Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        )
                      ],
                    );
                }

                );

          },
          icon: Icon(Icons.delete),
        ),),
        body: StreamBuilder<ItemDetails>(
          stream: ItemService(itemname: widget.item).ItemDETAILS,
          builder: (context,itemData){
            if(itemData.hasData){
              ItemDetails datas = itemData.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 10.0,
                      color: Colors.black,
                      child: GestureDetector(
                        onTap: (){
                          return Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (_,__,___) => ImageViewCustom(url: datas.url,),
                            transitionDuration: Duration(seconds: 0)
                          ));
                        },
                        child: Container(
                          color: Colors.black,
                          width: width ,
                          height:  height* .3,

                            child: Image.network(
                               datas.url,
                              fit: BoxFit.fitHeight,
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          RaisedButton(
                            shape: StadiumBorder(),
                            color: commonAssets.appbuttonColor,
                            onPressed: (){
                              return Navigator.push(context, PageRouteBuilder(
                                  pageBuilder: (_,__,___) => ItemUpdate(rent: datas.rent,oldimageurl: datas.url,itemid: widget.item,productname: datas.productname,),
                                  transitionDuration: Duration(seconds: 0)
                              ));
                            },
                            child: Icon(Icons.edit,color: commonAssets.commonbuttontextcolor,),
                          ),
                          RaisedButton(
                            shape: StadiumBorder(),
                            color: commonAssets.appbuttonColor,
                            onPressed: (){
                              return Navigator.push(context, PageRouteBuilder(
                                  pageBuilder: (_,__,___) => ItemHistory(productId: widget.item,),
                                  transitionDuration: Duration(seconds: 0)
                              ));
                            },
                            child: Icon(Icons.history,color: commonAssets.commonbuttontextcolor,),
                          ),

                        ],
                      ),
                    ),

                    Center(child: Text("Rent",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 5,),
                    Center(child: SelectableText(datas.rent.toString(),style: TextStyle(fontSize: 16.0,))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ProductName",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),

                          Text("ProductId",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:8.0,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: SelectableText(datas.productname,style: TextStyle(fontSize: 16.0,),)),

                          Flexible(child: SelectableText(datas.productid,style: TextStyle(fontSize: 16.0,)),)
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(

                        shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                        child: TableCalendar(
                          calendarStyle: CalendarStyle(
                            selectedColor: commonAssets.selecteddates
                          ),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                            formatButtonDecoration: BoxDecoration(
                              color: commonAssets.appbuttonColor,
                              borderRadius: BorderRadius.circular(10.0)

                            ),
                            formatButtonTextStyle: TextStyle(
                              color: commonAssets.commonbuttontextcolor
                            )
                          ),
                          events: _events,
                          // onDaySelected: (date,events,context){
                          //   setState(() {
                          //     _events[_calendarController.selectedDay]=[Colors.green];
                          //   });
                          // },
                          calendarController: _calendarController,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  datas.active ?  RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.2,vertical: height * 0.02),
                      shape: StadiumBorder(),
                      onPressed: (){
                        return Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (_,__,___)=>BookingItem(itemId: datas.productid,rent: datas.rent,events: _events,),
                          transitionDuration: Duration(seconds: 0)
                        ));
                      },
                      color: commonAssets.appbuttonColor,
                      child: Text(''
                          'Book',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: commonAssets.commonbuttontextcolor
                        ),
                      ),
                    ):Text('This Item Is Disable Now',style: TextStyle(color: commonAssets.error,fontSize: 16.0),),
                  ],
                ),
              );
            }
            else{
              return CircularLoading();
            }
          }
        )
      );
    }
  }
}
