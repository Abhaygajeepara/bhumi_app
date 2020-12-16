import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Common/Widget/drawer.dart';
import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:bhumi_app/Screens/ItemPage/Additem/Additem.dart';

import 'package:bhumi_app/Screens/ItemPage/ItemPage.dart';
import 'package:bhumi_app/Screens/Today/Todayorder.dart';
import 'package:bhumi_app/Service/AdditemService.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ItemDetails> _list;
  final TextEditingController _searchcontroller = new TextEditingController();
  bool issearch = false;
  List indexsearchlist = List();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;



   // configs();
  }
  @override
  Future serach(String name) async {
    indexsearchlist.clear();
    for (var i = 0; i < _list.length; i++) {
      bool local = _list[i].productid.contains(name);

      if (local) {
        indexsearchlist.add(_list[i]);
      } else {}
    }
  }
  Future configs()async{
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('iconapp');




    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: payloadnoti);
    var androidnotificationdetails = new AndroidNotificationDetails("Parin", 'Parin', 'Today Order');
    var generalNotificationDetails = new NotificationDetails(android: androidnotificationdetails);
    //flutterLocalNotificationsPlugin.show(0, "Parin", 'Nothing', generalNotificationDetails,payload: 'Parin');
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future payloadnoti(String payload){
    return showDialog(context: context,builder: (BuildContext context){
        return AlertDialog(
          content: Text(payload.toString()),
        );
    });
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: BasicAppbarwithTwoButton(
        IconButton(
          onPressed: ()async{
            return   await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TodayOrder(),
                transitionDuration: Duration(seconds: 0),
              ),
            );

          },
          icon: Icon(Icons.today),
        ),
        IconButton(
        onPressed: ()async{
          return   await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AddItem(),
              transitionDuration: Duration(seconds: 0),
            ),
          );

        },
        icon: Icon(Icons.add),
      ),

      ),
      body: StreamBuilder<List<ItemDetails>>(
          stream: ItemService(itemname: '').ITEMDATA,
        builder: (context,itemsnapshot){
            if(itemsnapshot.hasData){

                if(!issearch){
                  _list = itemsnapshot.data;
                }
                List<ItemDetails> datas = itemsnapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: inputdecoration.copyWith(
                          suffixIcon: !issearch
                              ? IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                          )
                              : IconButton(
                            onPressed: () {
                              _searchcontroller.clear();
                              setState(() {
                                issearch = false;
                              });
                            },
                            icon: Icon(Icons.clear),
                          )),
                      controller: _searchcontroller,
                      onChanged: (val) {
                        if (val.isEmpty) {
                          setState(() {
                            issearch = false;
                          });
                        } else {
                          setState(() {
                            issearch = true;
                            serach(val);
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: !issearch ? ListView.builder(
                        itemExtent: height * .3,
                        itemCount: datas.length,
                        itemBuilder:(context,index){

                          return customCard(context, datas[index]);

                        }
                    ):ListView.builder(
                        itemExtent: height * .3,
                        itemCount: indexsearchlist.length,
                        itemBuilder:(context,index){

                          return customCard(context, indexsearchlist[index]);

                        }
                    ),
                  )
                ],
              );

            }
            else{
              return CircularLoading();
            }
        }
      ),
      drawer: AppDrawerLocal(),

    );

  }
  Widget customCard(BuildContext context,ItemDetails localdata){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool active = localdata.active;
    return  Card(
    

      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: (){
          return Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_,__,___) => ItemPage(item: localdata.productid,),
              transitionDuration: Duration(seconds: 0)

          ));
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0)
              ),
              width: width * .3,
              height : height * .25,
              child: Image.network(
                localdata.url,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(localdata.productname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,


                      ),
                    ),
                  ),
                  Text(localdata.productid,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,


                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '₹'+localdata.rent.toString(),
                    style: TextStyle(
                        fontSize: 15.0
                    ),
                  ),
                  Switch(
                    value: localdata.active,
                    onChanged: (val)async{
                      await ItemService(itemname: localdata.productid).activeitem(active);
                    },
                  ),
                ],
              ),
            ),

          ],
        ),


      ),

    );
  }
}
