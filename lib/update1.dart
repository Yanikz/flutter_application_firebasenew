import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/users1.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Update1 extends StatefulWidget {
  const Update1({
    super.key,
    required this.user,
  });

  final Users1 user;

  @override
  State<Update1> createState() => _Update1State();
}

class _Update1State extends State<Update1> {
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController namecontroller;
  late TextEditingController emailcontroller;
  late String imgUrl;
  late String error;
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
    final path = 'files/${generateRandomString(8)}';
    print('update path Link: $path');
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      setState(() {
        uploadTask = ref.putFile(file);
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('update Download Link: $urlDownload');

    updateUser(widget.user.id, urlDownload);

    setState(() {
      Fluttertoast.showToast(msg:"Login Succesfully");
      uploadTask = null;
    });
  }

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController(
      text: widget.user.username,
    );
    passwordcontroller = TextEditingController(
      text: widget.user.password,
    );
    namecontroller = TextEditingController(
      text: widget.user.name,
    );
    emailcontroller = TextEditingController(
      text: widget.user.email,
    );
    imgUrl = widget.user.image;
    error = "";
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(40, 109, 108, 108), 
      appBar: AppBar(
        title: const Text('Update Account'),
          actions: [
       Image.asset(
                  'assets/images/reddit-logo.png',
                  width: 35,
                ),
        ],

        backgroundColor: Color.fromARGB(228, 0, 0, 0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Color.fromARGB(142, 158, 158, 158),
                    ),
                  ),
                  child: Center(
                    child: (pickedFile == null) ? checkImgVal() : imgExist(),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    selectFile();
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text('Add Photo'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),
                    controller: usernamecontroller,
                    decoration: const InputDecoration(
                      
                      border: OutlineInputBorder(),
                      labelText: 'Enter username',
                      labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                      
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter password',
                       labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter email',
                       labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),
                    controller: namecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter name',
                       labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      (pickedFile != null)
                          ? uploadFile()
                          : updateNoFile(widget.user.id);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Update',
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
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future updateUser(String id, String image) async {
    final docUser = FirebaseFirestore.instance.collection('Users1').doc(id);
    await docUser.update({
      'username': usernamecontroller.text,
      'password': passwordcontroller.text,
      'email': emailcontroller.text,
      'name': namecontroller.text,
      'image': image,
    });

    Navigator.pop(context);
  }

  Future updateNoFile(String id) async {
    final docUser = FirebaseFirestore.instance.collection('Users1').doc(id);
    await docUser.update({
      'username': usernamecontroller.text,
      'password': passwordcontroller.text,
      'email': emailcontroller.text,
      'name': namecontroller.text,
    });

    Navigator.pop(context);
  }

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.network(
        widget.user.image,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExistBlank() => Image.asset(
        'assets/images/no-image.png',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget checkImgVal() {
    return (widget.user.image == '-') ? imgNotExistBlank() : imgNotExist();
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}
