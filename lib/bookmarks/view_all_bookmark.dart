import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_firebasenew/userpost.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../redditcomment.dart';
import '../updatepost.dart';
import '../users1.dart';

class ViewAllBookmark extends StatefulWidget {
  const ViewAllBookmark({super.key});

  @override
  State<ViewAllBookmark> createState() => _ViewAllBookmarkState();
}

class _ViewAllBookmarkState extends State<ViewAllBookmark> {
  final user = FirebaseAuth.instance.currentUser!;

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Color.fromARGB(40, 109, 108, 108),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color.fromARGB(228, 0, 0, 0),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Bookmark",
                ),
              ],
            ),
            title: Text(
              "Reddit",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: StreamBuilder<List<UserPost>>(
            stream: readUserPost(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;

                return ListView(
                  children: users.map(newuserpost).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget newuserpost(UserPost userpost) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RedditComment(
                userPost: userpost,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            userline(userpost),
            Title(userpost),
            Body(userpost),
            const SizedBox(
              height: 15,
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: userpost.postimg,
                  height: 250,
                ),
              ),
            ),
            newbuttons(userpost),
          ],
        ),
      );

  Widget newbuttons(UserPost userpost) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: (!userpost.isLiked)
                        ? Colors.grey
                        : Color.fromARGB(255, 163, 63, 16),
                  ),
                  onPressed: () {
                    setState(() {
                      if (!userpost.isLiked) {
                        userpost.isLiked = true;
                        updateLike(userpost.post_id, true);
                      } else {
                        userpost.isLiked = false;
                        updateLike(userpost.post_id, false);
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_upward_outlined,
                    size: 20,
                  ),
                  label: const Text(
                    'Upvote',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RedditComment(
                          userPost: userpost,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.chat_bubble,
                    size: 20,
                  ),
                  label: const Text(''),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: (!userpost.favorites)
                        ? Colors.grey
                        : Color.fromARGB(255, 163, 63, 16),
                  ),
                  onPressed: () {
                    setState(() {
                      if (!userpost.favorites) {
                        userpost.favorites = true;
                        updatefavorites(userpost.post_id, true);
                        Fluttertoast.showToast(msg: "Bookmark Added");
                      } else {
                        userpost.favorites = false;
                        updatefavorites(userpost.post_id, false);
                        Fluttertoast.showToast(msg: "Un bookmark");
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.bookmark,
                    size: 20,
                  ),
                  label: const Text(''),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(27, 158, 158, 158),
          ),
        ],
      );
  Widget postimage(UserPost userpost) => Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(userpost.contentpost),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(userpost.postimg),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ));
  var nametxtStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  Widget userline(UserPost userpost) => Stack(
        children: [
          read3(user.uid),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.black54,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdatePost(
                                            userPost: userpost,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showActionSheet(
                                          context, userpost.post_id);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 26),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.grey.shade300),
                                child: const Text("Close",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      );

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
                Text(
                  userpost.contentpost,
                  style: nametxtStyle,
                ),
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

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        break;
    }
  }

  Stream<List<UserPost>> readUserPost() => FirebaseFirestore.instance
      .collection('UserPost')
      .where('favorites', isEqualTo: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => UserPost.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  updateLike(String id, bool status) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.update({
      'isLiked': status,
    });
  }

  updateDisliked(String id, bool status) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.update({
      'isDisliked': status,
    });
  }

  updatefavorites(String id, bool status) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.update({
      'favorites': status,
    });
  }

  updateunfavorites(String id, bool status) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.update({
      'favorites': status,
    });
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

  Widget buildUser2(Users1 user) => Container(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '   by • u/',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 139, 139, 139),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 139, 139, 139),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  deleteUser(String id) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.delete();
    Fluttertoast.showToast(msg: "Post Deleted");
    Navigator.pop(context);
  }

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

  Widget read2(uid) {
    var collection = FirebaseFirestore.instance.collection('Users1');
    return Column(
      children: [
        SizedBox(
          height: 40,
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
