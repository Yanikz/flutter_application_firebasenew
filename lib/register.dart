import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/login.dart';
import 'package:flutter_application_firebasenew/main.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_firebasenew/users1.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController namecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController imagecontroller;
  late String error;
  late String success;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

    Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;


    setState(() {
      pickedFile = result.files.first;
    });
  }
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadFile() async {
    
    final path = 'files/${generateRandomString(5)}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    createUser(urlDownload);

    setState(() {
      uploadTask = null;
    });
  }


  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    namecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    imagecontroller = TextEditingController();
    error = "";
    success = "";
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
    imagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black87,
                  size: 33,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            
              Padding(
                padding: const EdgeInsets.only(left:50),
                child: Image.asset(
                  'assets/images/reddit-logo.png',
                  width: 40,
                ),
              ),
             
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 13),
                child: Text("Sign up",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By continuing, you agree to our ',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'User Agreement',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                           
                          },
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                           
                          },
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(
                color: Color.fromARGB(255, 231, 226, 226),
                
                thickness: 2,
                
              ),
              const SizedBox(
                height: 12,
              ),
               Container(
                margin: const EdgeInsets.all(10),
               
                child: Center(
                  child: (pickedFile == null) ? imgNotExist() : imgExist(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  selectFile();
                },
                icon: const Icon(Icons.camera),
                label: const Text('Add Photo'),
              ),
               Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: namecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter name',
                    ),
                  ),
                ),
             Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: usernamecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter email',
                    ),
                  ),
                ),
             
              const SizedBox(
                height: 15,
              ),
             
             Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                     onPressed: () {

         registerUser();


                      
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                 Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ]),
      ),
    );
  }

  Future registerUser() async {

    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
       


       
      uploadFile();


      setState(() {
        Navigator.pop(context);
        Fluttertoast.showToast(msg:"Registered Succesfully");
        error = "";
        
      
      });
    } on FirebaseAuthException catch (e) {
            

      print(e);
      setState(() {
        error = e.message.toString();
        
      });
            

    }
    
    Navigator.pop(context);
  }

  Future createUser(urlDownload) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('Users1').doc(userid);

    final newUser = Users1(
      id: userid,
      username: usernamecontroller.text,
      password: passwordcontroller.text,
      email: emailcontroller.text,
      name: namecontroller.text,
      image: urlDownload,
    );

    final json = newUser.toJson();
    await docUser.set(json);
      setState(() {

      
    });


    Navigator.pop(context);
  }


  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Icon(
        Icons.person_add_alt_1_outlined,
        size: 30,
      );
}
