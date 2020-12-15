import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Screens/ItemPage/ItemHistory.dart';
import 'package:bhumi_app/Service/Bookinservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
class BookingItem extends StatefulWidget {
  String itemId;
  int rent;
  Map<DateTime,List<dynamic>> events;
  BookingItem({this.itemId,this.rent,this.events});
  @override
  _BookingItemState createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
    CalendarController _calendarController;
    String error = '';
  String c_name;
  String dateerror= '';
  String c_number;
  String c_address;
  List<String> _bookingdates = List();
String description;
  int discount;
  int advanced;
  int netamount ;
  bool setvaluetonetamount = false;
  bool autovalid =false;
  int extracharge;

  final _formkey =  GlobalKey<FormState>();
    DateTime _date =DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();

  }
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: BasicAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidate: autovalid,
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: inputdecoration.copyWith(labelText: "Customer Name"),
                  onChanged: (val)=> c_name =val,
                  validator: (val) => val.isEmpty ?'Enter The Customer Name':null,
                ),
                SizedBox(height: 10,),
                TextFormField(

                  keyboardType: TextInputType.phone,
                  decoration: inputdecoration.copyWith(labelText: "Customer Number"),
                  onChanged: (val)=> c_number =val,
                  validator: validatepincode,
                ),

                SizedBox(height: 10,),
                TextFormField(
                  maxLength: 70,
                  decoration: inputdecoration.copyWith(labelText: "Address"),
                  onChanged: (val)=> c_address =val,
                  validator: (val) => val.isEmpty ?'Enter The Customer Name':null,
                ),
                SizedBox(height: 10,),
                TextFormField(
                keyboardType: TextInputType.number,
                  decoration: inputdecoration.copyWith(labelText: "Advanced Money"),
                  onChanged: (val)=> advanced =int.parse(val),
                  validator:  numbervalidtion,
                ),
                SizedBox(height: 10,),
                Row(

                  children: [
                    Expanded(
                      child: TextFormField(

                        keyboardType: TextInputType.number,
                        decoration: inputdecoration.copyWith(labelText: "Discount"),
                        onChanged: (val)=> discount = int.parse(val),
                        validator:  numbervalidtion,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(

                        keyboardType: TextInputType.number,
                        decoration: inputdecoration.copyWith(labelText: "Extra Charge"),
                        onChanged: (val)=> extracharge = int.parse(val),
                        validator:  numbervalidtion,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),

                SizedBox(height: 10,),
                Card(
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
                    events: widget.events,
                    calendarController: _calendarController,
                    onDaySelected: (date,events,context){
                      setState(() {
                        String formatdate = DateFormat('yyyy-MM-dd').format(date);
                        bool dateexist =_bookingdates.contains(formatdate);
                        if(!dateexist){_bookingdates.add(formatdate);}

                      });
                      // _events[_calendarController.selectedDay]=[Colors.green];
                      print(_bookingdates);
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Text(dateerror.toString(),style: TextStyle(fontSize: 16.0,color: Colors.red),),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: Container(

                      height: height * 0.2,
                        child: ListView.builder(
                            itemCount: _bookingdates.length,
                            itemBuilder: (context,index){
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(flex : 3,child: Text(_bookingdates[index].toString())),
                                    Expanded(child: IconButton(onPressed: (){
                                      setState(() {
                                        _bookingdates.removeAt(index);
                                      });
                                    },icon: Icon(Icons.delete),),)

                                  ],
                                ),
                              );
                            }),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Text(error.toString(),style: TextStyle(
                  color: Colors.red
                ),),
                SizedBox(height: 5,),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: width *.2,vertical: height * .02),
                  color: commonAssets.appbuttonColor,
                  onPressed: ()async{
                    print(widget.itemId);
                    // return Navigator.push(context, PageRouteBuilder(
                    //   pageBuilder: (_,__,___)=>ItemHistory(productId: widget.itemId,),
                    //   transitionDuration: Duration(seconds: 1),
                    // ));
                    if(_formkey.currentState.validate())
                      {

                        if(_bookingdates.length == 0)
                          {
                            setState(() {
                              dateerror = 'Select The Dates of Booking';
                            });
                          }
                        else{

                          netamount = widget.rent  + extracharge - discount;
                          DateTime  convet = DateTime.parse(_bookingdates[0]);
                          DateTime pickupdate = DateTime(convet.year,convet.month,convet.day,0,0,0);
                          Timestamp pickup  = Timestamp.fromDate(pickupdate);

                          await BookingService().bookOrder(
                              widget.itemId, c_name, c_number, c_address, advanced,
                              discount, netamount, _bookingdates,extracharge,widget.rent,pickup);
                             await showDialog(
                                context:context,
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
                                                child: Text(advanced.toString()),

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
                                                child: Text(widget.rent.toString()),

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
                                                child: Text('+ '+extracharge.toString()),

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
                                                child: Text('- '+discount.toString()),

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
                                                child: Text(netamount.toString()),

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
                                                    itemCount: _bookingdates.length,
                                                    itemBuilder: (context,index){
                                                      return ListTile(
                                                        title: Text(_bookingdates[index].toString()),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      IconButton(
                                        icon: Icon(Icons.exit_to_app),
                                        onPressed: (){
                                         Navigator.pop(context);
                                         Navigator.pop(context);
                                         Navigator.push(context, PageRouteBuilder(
                                           pageBuilder: (_,__,___)=>ItemHistory(productId: widget.itemId,),
                                           transitionDuration: Duration(seconds: 0),
                                         ));
                                        },
                                      )
                                    ],
                                  );
                              }

                            ).then((value) {
                               Navigator.pop(context);
                               Navigator.push(context, PageRouteBuilder(
                                 pageBuilder: (_,__,___)=>ItemHistory(productId: widget.itemId,),
                                 transitionDuration: Duration(seconds: 0),
                               ));
                             } );


                        }
                      }
                    else{
                      setState(() {
                        autovalid = true;
                        error = 'All Fields Required';
                      });
                    }
                  },
                  shape: StadiumBorder(),
                  child: Text('Confirm',style: TextStyle(
                    color: commonAssets.commonbuttontextcolor,
                    fontSize: 16.0,
                  ),),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
  String validatepincode(String value) {
    Pattern pattern = r'^[0-9]{10}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter Valid  Mobile Number';
    } else {
      return null;
    }
  }

  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The Number Only';
    } else {
      return null;
    }
  }

}
