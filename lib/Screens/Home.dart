import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Screens/Additem/Additem.dart';
import 'package:bhumi_app/Screens/ItemPage/ItemPage.dart';
import 'package:bhumi_app/Service/AdditemService.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BasicAppbarwithButton(IconButton(
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
      ),),
      body: StreamBuilder<QuerySnapshot>(
          stream: ItemService(itemname: '').ITEMDATA,
        builder: (context,itemsnapshot){
            if(itemsnapshot.hasData){
              final localdata = itemsnapshot.data.docs;
              return ListView.builder(
                  itemExtent: height * .3,
                  itemCount: localdata.length,
                  itemBuilder:(context,index){
                    return Card(


                      shape:  RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: (){
                          return Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (_,__,___) => ItemPage(item: localdata[index].data()['ProductId'],),
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
                                localdata[index].data()['Image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20,),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(localdata[index].data()['Product'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,


                                  ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    '₹'+localdata[index].data()['Rent'].toString(),
                                    style: TextStyle(
                                        fontSize: 15.0
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),


                      ),

                    );

              } );

            }
            else{
              return CircularLoading();
            }
        }
      )
    );
  }
}
