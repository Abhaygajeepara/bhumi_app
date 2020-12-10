import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Screens/ItemPage/Imageview.dart';
import 'package:bhumi_app/Screens/ItemPage/booking.dart';
import 'package:bhumi_app/Service/AdditemService.dart';
import 'package:bhumi_app/Service/ItemService.dart';
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
  @override
  void initState() {
    // TODO: implement initState5
    super.initState();
    _calendarController = CalendarController();
  }
  @override
  Widget build(BuildContext context) {
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
            await ItemService(itemname: widget.item).deleteItem();
            return   Navigator.pop(context);

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
                      elevation: 20.0,
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
                          Text("ProductName",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                          Text("Rent",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
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
                          Flexible(child: SelectableText(datas.rent.toString(),style: TextStyle(fontSize: 16.0,)),),
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
                          calendarController: _calendarController,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.2,vertical: height * 0.02),
                      shape: StadiumBorder(),
                      onPressed: (){
                        return Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (_,__,___)=>BookingItem(itemId: datas.productid,rent: datas.rent,ordernumber: datas.ordernumber,),
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
                    )
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
