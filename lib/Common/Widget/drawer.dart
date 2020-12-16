import 'package:bhumi_app/Screens/History/History.dart';
import 'package:bhumi_app/Screens/Home.dart';
import 'package:bhumi_app/Screens/Income/income.dart';
import 'package:bhumi_app/Screens/ItemPage/DisableItem.dart';
import 'package:bhumi_app/Service/Auth/LoginAuto.dart';
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
                return Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => DisableItem(),
                    transitionDuration: Duration(milliseconds: 50)
                ));
                // return    await Navigator.of(context).pushNamedAndRemoveUntil(
                //     "disableitem",
                //         (route) => route.isCurrent && route.settings.name == "disableitem"
                //         ? false
                //         : true);

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
                return Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => AllHistory(),
                    transitionDuration: Duration(milliseconds: 50)
                ));
                // Navigator.pop(context);
                // return    await Navigator.of(context).pushNamedAndRemoveUntil(
                //     "allhistory",
                //         (route) => route.isCurrent && route.settings.name == "allhistory"
                //         ? false
                //         : true);

              },
              title: Row(
                children: <Widget>[
                  Icon(Icons.history),
                  SizedBox(width: 20,),
                  Text('History')
                ],
              )
          ),

          ListTile(
              onTap: ()async{
                Navigator.pop(context);

                return Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => Income(),
                    transitionDuration: Duration(milliseconds: 50)
                ));
                // return  Navigator.of(context).pushNamedAndRemoveUntil(
                //     "income",
                //         (route) => route.isCurrent && route.settings.name == "income"
                //         ? false
                //         : true);
              },
              title: Row(
                children: <Widget>[
                  Icon(Icons.account_balance),
                  SizedBox(width: 20,),
                  Text('Income')
                ],
              )
          ),
          ListTile(
              onTap: ()async{

                Navigator.pop(context);
                LogInAndSignIn().signouts();


              },
              title: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 20,),
                  Text('Log Out')
                ],
              )
          ),

        ],
      ),

    );
  }
}
