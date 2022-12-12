import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/usercomment.dart';
import 'package:flutter_application_firebasenew/users1.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Add_Comment extends StatefulWidget {
  const Add_Comment({
    super.key,
    required this.post_id,
  });

  final String post_id;
  @override
  State<Add_Comment> createState() => _Add_CommentState();
}

class _Add_CommentState extends State<Add_Comment> {
  late TextEditingController cmntCtrl;
  late TextEditingController cmntImgCtrl;
  late TextEditingController cmntNameCtrl;
  late TextEditingController cmntTimeCtrl;

  @override
  void initState() {
    super.initState();
    cmntCtrl = TextEditingController();
    cmntImgCtrl = TextEditingController();
    cmntNameCtrl = TextEditingController();
    cmntTimeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    cmntCtrl.dispose();
    cmntImgCtrl.dispose();
    cmntNameCtrl.dispose();
    cmntTimeCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(40, 109, 108, 108), 
      appBar: AppBar(
         backgroundColor: Color.fromARGB(228, 0, 0, 0),
       title: Text(
        "Reddit",
        style: TextStyle(color: Colors.white),
      ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                     style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    maxLines: 3,
                    controller: cmntCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write a comment',
                      hintStyle: TextStyle(
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
                      createComment();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'ADD COMMENT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future createComment() async {
    final docUser = FirebaseFirestore.instance.collection('UserComment').doc();

    final newComment = UserComment(
      commenterimg: cmntImgCtrl.text,
      commentername: cmntNameCtrl.text,
      commentime: cmntTimeCtrl.text,
      commentcontent: cmntCtrl.text,
      post_id: widget.post_id,
    );

    final json = newComment.toJson();
    await docUser.set(json);

    setState(() {
   
   Fluttertoast.showToast(msg:"Comment Added");
      cmntTimeCtrl.text = "";
      cmntCtrl.text = "";
    });

    Navigator.pop(context);
  }
 
  

  
      Widget iconImgExist(img) => CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(img),
      );

  Widget iconImgNotExist() => const Icon(
        Icons.account_circle_outlined,
        color: Colors.grey,
      );

  
}
