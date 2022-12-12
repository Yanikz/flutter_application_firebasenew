import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/add_post.dart';


import 'package:flutter_application_firebasenew/reddithome.dart';
import 'package:flutter_application_firebasenew/redditsettings.dart';



class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;

  final List _screen = [
    const RedditHome(),
    const Add_Post(),
    SettingPage(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
       
        unselectedItemColor: Colors.white,
        enableFeedback: true,
        currentIndex: _selectedIndex,
        onTap: ((value) {
          setState(() {
            _selectedIndex = value;
          });
        }),
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              activeIcon: Icon(Icons.add),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              activeIcon: Icon(Icons.settings),
              label: '')
        ],
      ),
    );
  }
}
