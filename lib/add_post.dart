
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/tabs.dart';
import 'package:flutter_application_firebasenew/userpost.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_firebasenew/users1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

enum ImageSourceType { gallery, camera }

class Add_Post extends StatefulWidget {
  const Add_Post({super.key});

  @override
  State<Add_Post> createState() => _Add_PostState();
}

class _Add_PostState extends State<Add_Post> {

  var _image;
  var imagePicker;
  var type;



  late TextEditingController postImgCtrl;
 

  late TextEditingController contentpostCtrl;
  late TextEditingController contentbodypostCtrl;

   late TextEditingController nameCtrl;


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
  String error = "";
  @override
  void initState() {
    super.initState();
  
    imagePicker = new ImagePicker();
    postImgCtrl = TextEditingController();
    nameCtrl = TextEditingController();
    contentpostCtrl = TextEditingController();
    contentbodypostCtrl = TextEditingController();
    
 
  }

  @override
  void dispose() {

    contentpostCtrl.dispose();
    contentbodypostCtrl.dispose();
    postImgCtrl.dispose();

  
    nameCtrl.dispose();
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
  
if (pickedFile == null) {
                        Fluttertoast.showToast(msg: "Please pick an Image");
                        return;
                      }
                        uploadFile();
                    
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          enableFeedback: false,
                          elevation: 20,
                          backgroundColor: Color.fromARGB(255, 204, 112, 38),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text(
                        'Add Post',
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


 Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Icon(
        Icons.camera_enhance_outlined, color: Colors.white,
      );

  Future createUser(urlDownload) async {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc();
  final user = FirebaseAuth.instance.currentUser!;
       final id = user.uid;
    final newPost = UserPost(

      post_id: docUser.id,
     
 
      postimg:urlDownload,

      contentpost: contentpostCtrl.text,
     contentbodypost: contentbodypostCtrl.text,
     id: id,
   
      isLiked: false,
      favorites: false,
    );

    final json = newPost.toJson();
    await docUser.set(json);

    setState(() {
     
    

      contentpostCtrl.text ="";
      contentbodypostCtrl.text ="";
      pickedFile = null; 
      Fluttertoast.showToast(msg:"Post Uploaded");
    });

    // ignore: use_build_context_synchronously
   
    Navigator.push (
                        context,
                         MaterialPageRoute(
                            builder: (context) => Tabs(),
                          ),
                      );
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
   
       Widget read(uid) {
    var collection = FirebaseFirestore.instance.collection('Users1');
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.doc(uid).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final users = snapshot.data!.data();
                final newUser = Users1(
                  id: users!['id'],
                  name: users['name'],
                  username: users['username'],
                  password: users['password'],
                  email: users['email'],
                 
                  image: users['image'],
                );

                return buildUser(newUser);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
  Widget buildUser(Users1 user) => Container(
        child: Padding(
          padding: const EdgeInsets.only(top:5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: (user.image != "-")
                          ? iconImgExist(user.image)
                          : iconImgNotExist(),
                    ),
                  ),
                  
                    Padding(
                    padding: const EdgeInsets.only(top:10),
                child:
                    Text(
                    
                      'r/',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
               
                     
  
                
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                child:
                    Text(
                    
                      user.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                
                  ),
                  SizedBox(
                    width: 3,
                  ),
                
                ],
              ),
            ],
          ),
 
          
        ),
        
      );
      Widget iconImgExist(img) => CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(img),
      );

  Widget iconImgNotExist() => const Icon(
        Icons.account_circle_outlined,
        color: Colors.grey,
      );
}

