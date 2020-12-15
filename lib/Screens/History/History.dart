import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Model/ItemHistoryModel.dart';
import 'package:bhumi_app/Service/Bookinservice.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllHistory extends StatefulWidget {




  @override
  _AllHistoryState createState() => _AllHistoryState();
}

class _AllHistoryState extends State<AllHistory> {
  List<ItemHistoryModel> _list;
  final TextEditingController _searchcontroller = new TextEditingController();
  bool issearch = false;
  List indexsearchlist = List();

  int subtactlocal(int rent, int extra) {
    var num = rent + extra;
    return num;
  }

  Future serach(String name) async {
    indexsearchlist.clear();
    for (var i = 0; i < _list.length; i++) {
      bool local = _list[i].prodcutid.contains(name);

      if (local) {
        indexsearchlist.add(_list[i]);
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: BasicAppbar(),
      body: StreamBuilder<List<ItemHistoryModel>>(
          stream: ItemService(itemname: 'null').HISTORY,
          builder: (context, historysanp) {
            if (historysanp.hasData) {
              List<ItemHistoryModel> datas = historysanp.data;
              if (!issearch) {
                print('false');
                _list = historysanp.data;
              }
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
                    child: !issearch
                        ? ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: (context, index) {



                          return customwidget(context,datas[index]);
                        })
                        : ListView.builder(
                        itemCount: indexsearchlist.length,
                        itemBuilder: (context, index) {
                          print('welcomw');


                          return customwidget(context,indexsearchlist[index]);
                        }),
                  )
                ],
              );
            } else if (historysanp.hasError) {
              return Container(
                child: Center(
                  child: Text('Not Booking Found',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              return CircularLoading();
            }
          }),
    );
  }
  Widget customAlert( BuildContext context, ItemHistoryModel localdata){
    final width  = MediaQuery.of(context).size.width;
    final height  = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Customer Name',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text(
                    localdata
                        .cus_name
                        .toString()),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Customer Address',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text(
                    localdata
                        .cus_address
                        .toString()),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Mobile Number',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text(
                    localdata
                        .cus_number
                        .toString()),
              ),
            ],
          ),
          Divider(
            thickness: 3,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Advanced',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text(
                    localdata
                        .advanced
                        .toString()),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Rent',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text(
                    localdata
                        .rentold
                        .toString()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Extra Charge',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text('+ ' +
                    localdata
                        .extracharge
                        .toString()),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(''),
              ),
              Flexible(
                child: Text(subtactlocal(
                    localdata
                        .rentold,
                    localdata
                        .extracharge)
                    .toString()),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Discount',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text('- ' +
                    localdata
                        .discount
                        .toString()),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 3.0,
            color: Colors.black,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Net Amount',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
              Flexible(
                child: Text(
                    localdata
                        .netrent
                        .toString()),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Booking Dates',
            style: TextStyle(
                fontWeight:
                FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets
                .symmetric(
                horizontal: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),

              ),
              elevation: 5.0,
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
                child:
                ListView.builder(
                    itemCount: localdata
                        .datelist
                        .length,
                    itemBuilder:
                        (context,
                        dateindex) {
                      return ListTile(
                        title: Text(localdata
                            .datelist[
                        dateindex]
                            .toString()),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customwidget(BuildContext context,ItemHistoryModel localdata){
    final  width = MediaQuery.of(context).size.width;
    final  height = MediaQuery.of(context).size.height;
    Timestamp bookingstamp =
        localdata.bookingdate;
    DateTime bookeddate = bookingstamp.toDate();
    bool colorcard =
        localdata.compeleteorder;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
        elevation: 10.0,
        color: colorcard
            ? Colors.grey.withOpacity(0.5)
            : Colors.white,
        child: GestureDetector(
          onLongPress: () async {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        'You Want To Delete This Order Record'),
                    content: Text('Are You Sure ?'),
                    actions: [
                      RaisedButton(
                        shape: StadiumBorder(),
                        onPressed: () async {
                          BookingService()
                              .OrderIdDelete(
                              localdata
                                  .orderIDtrack);
                          Navigator.pop(context);
                        },
                        color: commonAssets
                            .appbuttonColor,
                        child: Text('Delete It'),
                      )
                    ],
                  );
                });
          },
          onTap: () {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Customer Name',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    localdata
                                        .cus_name
                                        .toString()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Customer Address',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    localdata
                                        .cus_address
                                        .toString()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    localdata
                                        .cus_number
                                        .toString()),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 3,
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Advanced',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    localdata
                                        .advanced
                                        .toString()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Rent',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    localdata
                                        .rentold
                                        .toString()),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Extra Charge',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text('+ ' +
                                    localdata
                                        .extracharge
                                        .toString()),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(''),
                              ),
                              Flexible(
                                child: Text(subtactlocal(
                                    localdata
                                        .rentold,
                                    localdata
                                        .extracharge)
                                    .toString()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Discount',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text('- ' +
                                    localdata
                                        .discount
                                        .toString()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 3.0,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Net Amount',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    localdata
                                        .netrent
                                        .toString()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Booking Dates',
                            style: TextStyle(
                                fontWeight:
                                FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets
                                .symmetric(
                                horizontal: 20),
                            child: Card(
                              child: Container(
                                width: width * .5,
                                height: height * 0.25,
                                child:
                                ListView.builder(
                                    itemCount: localdata
                                        .datelist
                                        .length,
                                    itemBuilder:
                                        (context,
                                        dateindex) {
                                      return ListTile(
                                        title: Text(localdata
                                            .datelist[
                                        dateindex]
                                            .toString()),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      RaisedButton(
                        color: commonAssets
                            .appbuttonColor,
                        onPressed: () async {
                          BookingService()
                              .completeOrder(
                              localdata
                                  .orderIDtrack,
                              !colorcard);
                          Navigator.pop(context);
                        },
                        child: Text('Complete Order'),
                      )
                    ],
                  );
                });
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(localdata.prodcutid),
                Text('( Order:' +
                    bookeddate
                        .toString()
                        .substring(0, 11) +
                    ')'),
                Text('(Book :' +
                    localdata
                        .datelist[0] +
                    ')'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

