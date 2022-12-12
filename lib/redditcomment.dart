import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/add_comment.dart';
import 'package:flutter_application_firebasenew/updatepost.dart';
import 'package:flutter_application_firebasenew/usercomment.dart';
import 'package:flutter_application_firebasenew/userpost.dart';
import 'package:flutter_application_firebasenew/users1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RedditComment extends StatefulWidget {
  const RedditComment({
    super.key,
    required this.userPost,
  });

  final UserPost userPost;

  @override
  State<RedditComment> createState() => _RedditCommentState();
}

class _RedditCommentState extends State<RedditComment> {
  final user = FirebaseAuth.instance.currentUser!;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(40, 109, 108, 108),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(228, 0, 0, 0),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text(
          'Reddit',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Add_Comment(post_id: widget.userPost.post_id),
                ),
              );
            },
            icon: const Icon(
              Icons.chat_bubble,
              color: Colors.grey,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              userline(widget.userPost),
              Title(widget.userPost),
              Body(widget.userPost),
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: widget.userPost.postimg,
                    height: 250,
                  ),
                ),
              ),
              buttons(widget.userPost),
              fetchComments(),
            ],
          ),
        ],
      ),
    );
  }

  Widget Title(UserPost userpost) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                Text(userpost.contentpost, style: nametxtStyle),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      );

  Widget Body(UserPost userpost) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  userpost.contentbodypost,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      );

  Widget fetchComments() {
    return StreamBuilder<List<UserComment>>(
      stream: readUserComment(widget.userPost.post_id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final users = snapshot.data!;

          return ListView(
            shrinkWrap: true,
            children: users.map(usercommenterline).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget userpostdetails(UserPost userPost) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: userPost.postimg,
                height: 250,
              ),
            ),
          ),
          buttons(userPost),
          fetchComments(),
        ],
      );

  Widget usercommenterline(UserComment userComment) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: read2(user.uid),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(0, 158, 158, 158),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Row(
                          children: [
                            Text(
                              userComment.commentcontent,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  Widget read3(uid) {
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

                return buildUser3(newUser);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildUser3(Users1 user) => Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
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
                    radius: 23,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'assets/images/flutter.png',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '  r/',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Flutter',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 241, 229, 229),
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

  Widget buttons(UserPost userPost) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: (!userPost.isLiked)
                        ? Colors.grey
                        : Color.fromARGB(255, 163, 63, 16),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_upward_outlined,
                    size: 20,
                  ),
                  label: const Text(''),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_bubble,
                    size: 20,
                  ),
                  label: const Text(''),
                ),
                /*
                 TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: (!userPost.favorites) ? Colors.grey : Color.fromARGB(255, 163, 63, 16),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark,
                    size: 20,
                  ),
                  label: const Text(''),
                ),
                */
              ],
            ),
          ),
        ],
      );
  Widget imgExist(img) => Container(
        height: 350,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.white70),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(img),
            fit: BoxFit.fill,
          ),
        ),
      );

  Widget imgNotExist() => const Icon(
        Icons.account_circle_rounded,
        size: 40,
      );
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

  Widget read2(uid) {
    var collection = FirebaseFirestore.instance.collection('Users1');
    return Column(
      children: [
        SizedBox(
          height: 30,
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

                return buildUser2(newUser);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget iconImgExist(img) => CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(img),
      );

  Widget iconImgNotExist() => const Icon(
        Icons.account_circle_outlined,
        color: Colors.grey,
      );
  Widget buildUser(Users1 user) => Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
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
                    radius: 23,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: (user.image != "-")
                          ? iconImgExist(user.image)
                          : iconImgNotExist(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '  r/',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Flutter',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 241, 229, 229),
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
  Widget buildUser2(Users1 user) => Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
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
                    radius: 15,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: (user.image != "-")
                          ? iconImgExist(user.image)
                          : iconImgNotExist(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '  u/',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 241, 229, 229),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget userline(UserPost userpost) => Stack(
        children: [
          read3(user.uid),
        ],
      );

  deleteUser(String id) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.delete();
    Navigator.pop(context);
  }

  Widget postimage(UserPost userPost) => Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(userPost.contentpost),
            ],
          ),
          Row(
            children: [
              Text(userPost.contentbodypost),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ));
  var nametxtStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Color.fromARGB(255, 255, 255, 255),
  );
  var boldtxtStyle = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  var boldtxtStyle1 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Stream<List<UserComment>> readUserComment(id) => FirebaseFirestore.instance
      .collection('UserComment')
      .where('post_id', isEqualTo: id)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => UserComment.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
  Stream<List<UserComment>> readLastCommenter(id) => FirebaseFirestore.instance
      .collection('UserComment')
      .where('post_id', isEqualTo: id)
      .limit(1)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => UserComment.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
  void _showActionSheet(BuildContext context, String id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: TextButton.icon(
          style: TextButton.styleFrom(
            primary: Color.fromARGB(255, 0, 0, 0),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Confirmation'),
                message: const Text(
                    'Are you sure you want to delete this user? Doing this will not undo any changes.'),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      deleteUser(id);
                    },
                    child: const Text('Continue'),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          },
          icon: const Icon(Icons.delete, size: 20),
          label: Text('Delete'),
        ),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
