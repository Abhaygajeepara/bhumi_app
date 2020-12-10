import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class CalenderScreen extends StatefulWidget {
  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  CalendarController _calendarController;

  Map<DateTime,List<dynamic>> _events;
  DateTime _date =DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    _events = {
      _date:[Colors.red],
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TableCalendar(

              events: _events,
              headerStyle: HeaderStyle(
                decoration: BoxDecoration(
                  color:Colors.red
                )
              ),
              onDaySelected:(date,events,context){
                DateTime _date = DateTime(2020,11,21);
                setState(() {
                  _events[_calendarController.selectedDay]=[Colors.green];
                });
              } ,
                builders: CalendarBuilders(

                ),
              calendarController: _calendarController,
            ),
            RaisedButton(
              onPressed: (){
                DateTime _date = DateTime(2020,11,22);

              },
            ),

          ],
        ),
      ),
    );
  }
}
