import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/project_status.dart';
import 'package:flutter_firebase/screens/onlinepayment.dart';

import 'package:flutter_firebase/screens/projecterror.dart';
import 'package:flutter_firebase/screens/projectupdate.dart';
import 'package:flutter_firebase/screens/Topscard.dart';
import 'package:flutter_firebase/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_drawer_header.dart';
import 'screens/Event.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _clientName;

  @override
  void initState() {
    super.initState();
    _getUserDrawer();

  }
  Future<void> _getUserDrawer() async {
    final prefs = await SharedPreferences.getInstance();
    final clientName=prefs.getString('client_name');
    setState(() {
      _clientName= clientName;


    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Container(
            child: Row(
              children: [
                Icon(Icons.waving_hand, color: Colors.orange),
                SizedBox(width: 8.0),
                Text(
                  "$_clientName",
                  style: TextStyle(fontSize: 25.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          TopCard(),
        ]
        /* Center(
          child: Text('Number of projects: $_projectCount'),
        )*/
        ,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            MyHeaderDrawer(),
            ListTile(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
            },
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: (Text(
                'Home',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectStatus()));
              },
              leading: Icon(
                Icons.mail,
                color: Colors.grey,
              ),
              title: (Text(
                'Project Status',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlinePayment()));
            },
              leading: Icon(
                Icons.outgoing_mail,
                color: Colors.grey,
              ),
              title: (Text(
                'Online Payment',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectUpdate()));
            },
              leading: Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              title: (Text(
                'Project Update',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectError()));
            },
              leading: Icon(
                Icons.contact_page,
                color: Colors.grey,
              ),
              title: (Text(
                'Project Error',
                style: TextStyle(color: Colors.white),
              )),
            ),
          ListTile(onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Event()));
    },
      leading: Icon(
        Icons.contact_page,
        color: Colors.grey,
      ),
      title: (Text(
        'Event',
        style: TextStyle(color: Colors.white),
      )),
    ),
            ListTile(onTap: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_id', null);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SigninScreen()),
              );
            },
              leading: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: (Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              )),
            )

            // add more ListTiles for additional options
          ],
           ),
        backgroundColor: Colors.transparent.withOpacity(0.3),),
    );
  }
}
