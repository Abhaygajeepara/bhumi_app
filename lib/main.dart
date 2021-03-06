import 'package:bhumi_app/Screens/Calender.dart';
import 'package:bhumi_app/Screens/History/History.dart';
import 'package:bhumi_app/Screens/Home.dart';
import 'package:bhumi_app/Screens/Income/income.dart';
import 'package:bhumi_app/Screens/ItemPage/DisableItem.dart';
import 'package:bhumi_app/Screens/ItemPage/ItemPage.dart';
import 'package:bhumi_app/Screens/ItemPage/booking.dart';
import 'package:bhumi_app/Service/Auth/LoginAuto.dart';
import 'package:bhumi_app/Wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Workmanager.initialize(
  //
  //   //
  //     configs,
  //
  //
  //     isInDebugMode: true
  // );
  // Periodic task registration
  // Workmanager.registerOneOffTask(
  //   "2",
  //
  //
  //   "simplePeriodicTask",
  //
  // );
  runApp(MyApp());

}
// Future configs()async{
//   Workmanager.executeTask((task, inputData)async {
//     tz.initializeTimeZones();
//     var locations = tz.timeZoneDatabase.locations;
//     var flutterLocalNotificationsPlugin;
//     final NotificationAppLaunchDetails notificationAppLaunchDetails =
//     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('iconapp');
//
//
//
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: 's');
//     var androidnotificationdetails = new AndroidNotificationDetails("Parin", 'Parin', 'Today Order');
//     var generalNotificationDetails = new NotificationDetails(android: androidnotificationdetails);
//     //flutterLocalNotificationsPlugin.show(0, "Parin", 'Nothing', generalNotificationDetails,payload: 'Parin');
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'scheduled title',
//         'scheduled body',
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails('your channel id',
//                 'your channel name', 'your channel description')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime);
//     return Future.value(true);
//   });

// }
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: LogInAndSignIn().USERDATA,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/' :(context) => Wrapper(),
          'home' :(context) => Home(),
          'item' :(context) => ItemPage(),
          'booking' :(context) => BookingItem(),
          'disableitem':(context)=>DisableItem(),
          'income':(context)=>Income(),
            'allhistory':(context)=>AllHistory(),

        },
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
    onPressed: fectData,
        // onPressed: (){
        //   // FirebaseFirestore.instance.collection("jay").doc("abhay").get().then((value){
        //   //   Timestamp s = value.data()['first'];
        //   //  DateTime time = s.toDate();
        //   //
        //   //   print(time.day);
        //   // });
        //   // DateTime time = DateTime(2020,12,15);
        //   //
        //   // print(time.millisecondsSinceEpoch);
        //   // final stamp = Timestamp.fromDate(time);
        //   //
        //   // FirebaseFirestore.instance.collection("jay").where("first",isLessThan: stamp).orderBy('first',descending: true).limit(1).get().then((value){
        //   //   final val = value.docs;
        //   //   for(DocumentSnapshot d in val){
        //   //     Timestamp s = d.data()['first'];
        //   //     DateTime time = s.toDate();
        //   //
        //   //     print(time.day);
        //   //     print(d.id);
        //   //   }
        //   // });
        //   DateTime time = DateTime(2020,12,15);
        //
        //   print(time.millisecondsSinceEpoch);
        //   final stamp = Timestamp.fromDate(time);
        //   DateTime endtime = DateTime(2020,12,15);
        //
        //   print(time.millisecondsSinceEpoch);
        //   final endstamp = Timestamp.fromDate(endtime);
        //
        //   FirebaseFirestore.instance.collection("jay").where("first",isLessThan: stamp).orderBy('first',descending: true).limit(1).get().then((value){
        //     final val = value.docs;
        //     for(DocumentSnapshot d in val){
        //       Timestamp s = d.data()['first'];
        //       DateTime time = s.toDate();
        //
        //       print(time.day);
        //       print(d.id);
        //     }
        //   });
          // FirebaseFirestore.instance.collection("jay").doc('haa').set({'first':stamp});
        // },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void fectData(){
    Timestamp timestampStart = Timestamp.fromDate(DateTime(2021,1,1));
    Timestamp timestampEnd = Timestamp.fromDate(DateTime(2021,1,31));
    // FirebaseFirestore.instance.collection("/designs/choli-2/orders")
    //     .where("start",isGreaterThan: timestampStart,isLessThan: timestampEnd).get()
    // .then((value){
    //   final docs = value.docs;
    //   for(DocumentSnapshot dd in docs){
    //     print(dd.id);
    //   }
    // });
    FirebaseFirestore.instance.collection("/designs/choli-2/orders")
    .where("start",isLessThan: timestampStart).where("start",isGreaterThan: timestampStart).get()
    .then((value){
      final docs = value.docs;
        for(DocumentSnapshot dd in docs) {
          print(dd.id);
        }
    });
  }
}
