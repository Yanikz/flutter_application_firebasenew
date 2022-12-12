
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/profile.dart';
import 'package:flutter_application_firebasenew/update1.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;





  @override


  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('Users1')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
           backgroundColor: Color.fromARGB(40, 109, 108, 108),
     appBar: AppBar(
      elevation: 0.0,
      backgroundColor: Color.fromARGB(228, 0, 0, 0),

      title: Text(
        "Reddit",
        style: TextStyle(color: Colors.white),
      ),
    ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                       style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),
                      decoration: InputDecoration(
                        
                        hintText: "Search",
                         hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                        Navigator.push (
                        context,
                        MaterialPageRoute(builder:(context) =>  const Profile(),
                      ),
                      );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userMap!['image']) ,
                        ),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        subtitle: Text(userMap!['email'],
                         style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          
                          ),),
         
                      )
                    : Container(),
              ],
            ),
    
    );
  }
}