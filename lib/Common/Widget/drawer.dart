import 'package:bhumi_app/Screens/Home.dart';
import 'package:bhumi_app/Screens/ItemPage/DisableItem.dart';
import 'package:flutter/material.dart';

class AppDrawerLocal extends StatefulWidget {
  @override
  _AppDrawerLocalState createState() => _AppDrawerLocalState();
}

class _AppDrawerLocalState extends State<AppDrawerLocal> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            onTap: ()async{
              Navigator.pop(context);
             return await Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (_,__,___) => Home(),
                  transitionDuration: Duration(seconds: 0)

              ));
            },
              title: Row(
                children: <Widget>[
                  Icon(Icons.home),
                  SizedBox(width: 20,),
                  Text('Home')
                ],
              )
          ),
          ListTile(
              onTap: ()async{
                Navigator.pop(context);
               return await Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => DisableItem(),
                    transitionDuration: Duration(seconds: 0)

                ));
              },
              title: Row(
                children: <Widget>[
                  Icon(Icons.do_not_disturb_alt),
                  SizedBox(width: 20,),
                  Text('Disable Item')
                ],
              )
          ),
          ListTile(
              onTap: ()async{
                Navigator.pop(context);
                return await Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => DisableItem(),
                    transitionDuration: Duration(seconds: 0)

                ));
              },
              title: Row(
                children: <Widget>[
                  Icon(Icons.account_balance),
                  SizedBox(width: 20,),
                  Text('Disable Item')
                ],
              )
          ),

        ],
      ),

    );
  }
}
