import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseImages extends StatefulWidget {
  const FirebaseImages({super.key});

  @override
  State<FirebaseImages> createState() => _FirebaseImagesState();
}

class _FirebaseImagesState extends State<FirebaseImages> {
  var imgUrl;
  @override
  void initState() {
    super.initState();
    imgUrl = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    downloadURLExample();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imgUrl != null)
            Center(
              child: Image.network(imgUrl),
            ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }

  Future<void> downloadURLExample() async {
    final downloadURL = await FirebaseStorage.instance
        .ref()
        .child("files/IMG_0011.JPG")
        .getDownloadURL();

    setState(() {
      imgUrl = downloadURL;
    });
  }
}
