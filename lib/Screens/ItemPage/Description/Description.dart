import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemDetail.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  String item;
  Description({this.item});
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String description;
  final descriptionkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(),
      body: StreamBuilder<ItemDetails>(
        stream: ItemService(itemname: widget.item).ItemDETAILS,
        builder: (context,snapshot){
          if(snapshot.hasData){
                ItemDetails datas = snapshot.data;
                List<String> descriptionlist = List.from(datas.description);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.black,width: 0.5),
                          bottom: BorderSide(color: Colors.black,width: 0.5),
                          right: BorderSide(color: Colors.black,width: 0.5),
                          left: BorderSide(color: Colors.black,width: 0.5),
                        )
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                        key: descriptionkey,
                        child: Column(
                          children: [
                            Text('Description',style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    decoration: inputdecoration.copyWith(labelText: 'Details',),
                                    validator: (val) =>
                                    val.isEmpty ? 'Enter The Details' : null,
                                    onChanged: (val) => description = val,
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      if (descriptionkey.currentState.validate()) {
                                        ItemService(itemname: widget.item).addDescriptionElement(description);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: descriptionlist.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext, index) {
                                    List<String> _reverseddetailslist =
                                   descriptionlist.reversed.toList();
                                    return ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  _reverseddetailslist[index].toString()
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: Icon(Icons.cancel),
                                                onPressed: ()async{
                                                  int deleteindex = descriptionlist.length-1 -index;

                                                  ItemService(itemname: widget.item).deleteDescriptionElement(descriptionlist[deleteindex]);

                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
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
