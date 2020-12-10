import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingItem extends StatefulWidget {
  String itemId;
  int rent;
  int ordernumber;
  BookingItem({this.itemId,this.rent,this.ordernumber});
  @override
  _BookingItemState createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
    CalendarController _calendarController;
  String c_name;
  String dateerror= '';
  String c_number;
  String c_address;
  List<String> _bookingdates = List();
  Map<DateTime,List<dynamic>> _events;
  int discount;
  int advanced;
  int netamount ;
  bool autovalid =false;


  final _formkey =  GlobalKey<FormState>();
    DateTime _date =DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    _events={_date:['ss']};
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: inputdecoration.copyWith(labelText: "Discount"),
                  onChanged: (val)=> discount =int.parse(val),
                  validator:  numbervalidtion,
                ),
                SizedBox(height: 10,),

                Card(
                  child: TableCalendar(
                    events: _events,
                    calendarController: _calendarController,
                    onDaySelected: (date,events,context){
                      setState(() {


                          String formatdate = DateFormat('yyyy-MM-dd').format(date);




                        _bookingdates.add(formatdate);
                      });
                      // _events[_calendarController.selectedDay]=[Colors.green];
                      print(_bookingdates);
                    },
                  ),
                ),
                SizedBox(height: 30,),
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
                SizedBox(height: 20,),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: width *.2,vertical: height * .02),
                  color: commonAssets.appbuttonColor,
                  onPressed: (){
                    if(_formkey.currentState.validate())
                      {
                        // print(c_name);
                        // print(c_number);
                        // print(c_address);
                        // print(advanced);
                        // print(discount);
                        if(_bookingdates.length == 0)
                          {
                            setState(() {
                              dateerror = 'Select The Dates of Booking';
                            });
                          }
                        else{
                          netamount = widget.rent - discount;
                          print('netamount = $netamount');
                        }
                      }
                    else{
                      setState(() {
                        autovalid = true;
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
