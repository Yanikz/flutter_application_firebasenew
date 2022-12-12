import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/homescreen.dart';
import 'package:flutter_application_firebasenew/main.dart';
import 'package:flutter_application_firebasenew/pages/home.dart';
import 'package:flutter_application_firebasenew/profile.dart';
import 'package:flutter_application_firebasenew/profile1.dart';

import 'package:flutter_application_firebasenew/reddithome.dart';
import 'package:flutter_application_firebasenew/searchscreen.dart';
import 'package:flutter_application_firebasenew/update1.dart';
import 'package:flutter_application_firebasenew/updateprofile.dart';
import 'package:flutter_application_firebasenew/userpost.dart';
import 'package:flutter_application_firebasenew/users1.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingPage extends StatefulWidget {

  @override
  State<SettingPage> createState() => _SettingPageState();
}
 int _selectedIndex = 0; 
class _SettingPageState extends State<SettingPage> {
  String title = 'AlertDialog';
  bool tappedYes = false;
  int _currentIndex= 0;


  final List<Widget> _posts = <Widget>[
  
  ];
  
  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

  Widget renderAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.black38,
      
      title: Text(
        "Reddit",
        style: TextStyle(color: Colors.white),
      ),
    
      
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromARGB(40, 109, 108, 108), 
   
          appBar: AppBar(
      elevation: 0.0,
      backgroundColor: Color.fromARGB(228, 0, 0, 0),
      
      title: const Text(
        "Reddit",
        style: TextStyle(color: Colors.white),
      ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             IconButton(
            icon: Icon(color: Color.fromARGB(255, 199, 199, 199),Icons.logout_rounded),
            onPressed: () async {
              final action = await AlertDialogs.yesCancelDialog(
                  context, 'Logout', 'Are you sure you want to Logout?');
              if (action == DialogsAction.yes) {
                  Fluttertoast.showToast(msg:"Login Succesfully");
                setState(
                 
                  () => tappedYes = true
             
                );
              } else {
                setState(() => tappedYes = false);
              }
            },
          )
            ],
          )
        ],
    ),
           body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            children: [
              ListTile(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                   color: Color.fromARGB(255, 177, 90, 39),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                leading: Icon( color: Color.fromARGB(255, 199, 199, 199),Icons.account_circle),
                onTap: () {
                  Navigator.push (
                        context,
                        MaterialPageRoute(builder:(context) =>  const Profile(),
                      ),
                      );
                },
              ),
              
   
              
         /*     ListTile(
                title: const Text(
                  'Saved Posts',
                  style: TextStyle(
                   color: Color.fromARGB(255, 177, 90, 39),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                leading: Icon(color: Color.fromARGB(255, 199, 199, 199),Icons.bookmark_border),
                onTap: () {
        Navigator.push (
                        context,
                        MaterialPageRoute(builder:(context) =>  const HomePage(),
                      ),
                      );
                },
              ),
      
          */     
                   
              ListTile(
                title: const Text(
                  'News',
                  style: TextStyle(
                   color: Color.fromARGB(255, 177, 90, 39),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                leading: Icon(color: Color.fromARGB(255, 199, 199, 199),Icons.newspaper),
                onTap: () {
        Navigator.push (
                        context,
                        MaterialPageRoute(builder:(context) =>  const HomePage(),
                      ),
                      );
                },
              ),

              ListTile(
                title: const Text(
                  'Search User',
                  style: TextStyle(
                   color: Color.fromARGB(255, 177, 90, 39),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                leading: Icon(color: Color.fromARGB(255, 199, 199, 199),Icons.people),
                onTap: () {
         Navigator.push (
                        context,
                        MaterialPageRoute(builder:(context) =>  const SearchScreen(),
                      ),
                      );
                },
              ),
              
             
            ],
          ),
        ),
        

        
          
        )
        
      )
    );
    
  }
    Widget iconImgExist(img) => CircleAvatar(
        radius: 45,
        backgroundImage: NetworkImage(img),
      );

  Widget iconImgNotExist() => const Icon(
        Icons.account_circle_outlined,
        color: Colors.grey,
      );
  
  Widget buildUser(Users1 user) => Container(
        transform: Matrix4.translationValues(0.0, -40.0, 0.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 43,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: (user.image != "-")
                        ? iconImgExist(user.image)
                        : iconImgNotExist(),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0.0,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.black),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Update Profile',
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfile(
                            user: user,
                          ),
                        ));
                  },
                ),
              ],
            ),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: 5,
            ),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [   
                Icon(
                  Icons.calendar_today,
                  size: 15,
                ),
              
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.location_on_outlined,
                  size: 15,
                ),
               
              ],
            ),
           
          ],
        ),
      );
}
enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () =>
              
                  Navigator.of(context).pop(FirebaseAuth.instance.signOut()),
                  
                    
                  
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.w700),
              ),
            )
          ],
      
        );
      },
      
    );
    return (action != null) ? action : DialogsAction.cancel;
    
  }
}