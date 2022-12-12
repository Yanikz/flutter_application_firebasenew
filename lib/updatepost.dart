import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/userpost.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdatePost extends StatefulWidget {
  const UpdatePost({
    super.key,
    required this.userPost,
  });

  final UserPost userPost;

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {




  late TextEditingController postImgCtrl;
 

  late TextEditingController contentpostCtrl;
  late TextEditingController contentbodypostCtrl;

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
    final path = 'files/${generateRandomString(5)}';
    
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

    updatePost(widget.userPost.post_id, urlDownload);

    setState(() {
      uploadTask = null;
        Fluttertoast.showToast(msg:"Post Updated");
    });
  }

  @override
  void initState() {
    super.initState();
    contentpostCtrl = TextEditingController(
      text: widget.userPost.contentpost,
    );
     contentbodypostCtrl = TextEditingController(
      text: widget.userPost.contentbodypost
    );
   
    imgUrl = widget.userPost.postimg;
    error = "";
  }

  @override
  void dispose() {
   contentpostCtrl.dispose();
    contentbodypostCtrl.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 1,
                  ),
                  child: TextField(
                     style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                    maxLines: 3,
                    controller: contentpostCtrl,
                    
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add a title ',
                      hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )

                      
                    ),
                  ),
                ),
                 Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 1,
                  ),
                  child: TextField(
                     style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    maxLines: 3,
                    controller: contentbodypostCtrl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add body text ',
                       hintStyle: TextStyle(
                  
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                    ),
                  ),
                ),

              
                addimage(),

                const SizedBox(
                  height: 10,
                ),
              ],
              
            ),
            
          ),
               Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: ElevatedButton(
                      onPressed: () {
                        if (contentpostCtrl.text.isEmpty ||
                            contentbodypostCtrl.text.isEmpty 
                         
                           ) {
                          showDialog(
                            context: context,
                            useRootNavigator: false,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              content: const Text("Fill-in all fields"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Confirm"))
                              ],
                            ),
                          );
                        } else {
  
                      (pickedFile != null)
                          ? uploadFile()
                          : updateNoFile(widget.userPost.post_id);
                    
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 20,
                          backgroundColor: Color.fromARGB(255, 204, 112, 38),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text(
                        'Update Post',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'DelaGothic'),
                      ),
                    ),
                  ),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  buildProgress(),
        ],
      ),
    );
  }
  Widget addimage() => Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          child: Center(
            child: GestureDetector(
              onTap: () {
                selectFile();
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent),
                child: (pickedFile == null) ? imgNotExist() : imgExist(),
              ),
            ),
          ),
        ),
      );

  Future updatePost(String id, String image) async {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    await docUser.update({
      'contentpost': contentpostCtrl.text,
      'contentbodypost': contentbodypostCtrl.text,
    
      'postimg': image,
    });

    Navigator.pop(context);
  }

  Future updateNoFile(String id) async {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    await docUser.update({
      'contentpost': contentpostCtrl.text,
      'contentbodypost': contentbodypostCtrl.text,
  
    });

    Navigator.pop(context);
  }
  final user = FirebaseAuth.instance.currentUser!;
  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.network(
        widget.userPost.postimg,
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
    return (widget.userPost.postimg == '-') ? imgNotExistBlank() : imgNotExist();
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
