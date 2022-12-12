import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../models/model.dart';
import '../service/service.dart';
import 'dart:async';

import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>?> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
     
    return Scaffold(
         backgroundColor: Color.fromARGB(239, 0, 0, 0), 
        appBar: AppBar(
                backgroundColor: Color.fromARGB(228, 0, 0, 0),
     title: const Text('News'), actions: [
          isListView
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isListView = false;
                    });
                  },
                  icon: const Icon(Icons.grid_view_outlined))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isListView = true;
                    });
                  },
                  icon: const Icon(Icons.toc)),
        ]),
        body: Center(
          child: FutureBuilder<List<Article>?>(
            future: futureAlbum,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return isListView ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 40,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: SizedBox(
                          width: width,
                          height: 100.0,
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xFFBDBDBD),
                            highlightColor: const Color(0xFF9E9E9E),
                            child: const Card(),
                          ),
                        ),
                      );
                    }) : Shimmer.fromColors(
                            baseColor: const Color(0xFFBDBDBD),
                            highlightColor: const Color(0xFF9E9E9E),
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: height / (width * 2.7),
                                ),
                                itemCount: 40,
                                itemBuilder: (BuildContext context, int index) {
                                  return const Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),),
                                  );
                                }),
                          ),
                        ),
                    );
              }
              if (snapshot.hasData) {
                return isListView
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: SizedBox(
                              height: 100,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(const DetailPage(), arguments: [
                                    {
                                      'title': data.title,
                                      'image': data.urlToImage,
                                      'date': data.publishedAt,
                                      'author': data.author,
                                      'description': data.description,
                                    }
                                  ]);
                                },
                                child: Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text('${data.title}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                                '${data.publishedAt}'
                                                    .substring(0, 10),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ),
                                      data.urlToImage != null
                                          ? Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Hero(
                                                tag: '${data.urlToImage}',
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(data
                                                            .urlToImage
                                                            .toString()),
                                                        fit: BoxFit.fitHeight),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const CircularProgressIndicator(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: height / (width * 2.7),
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = snapshot.data![index];
                                return GestureDetector(
                                onTap: () {
                                  Get.to(const DetailPage(), arguments: [
                                    {
                                      'title': data.title,
                                      'image': data.urlToImage,
                                      'date': data.publishedAt,
                                      'author': data.author,
                                      'description': data.description,
                                    }
                                  ]);
                                },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          data.urlToImage != null
                                              ? Hero(
                                                tag: '${data.urlToImage}',
                                                child: Container(
                                                    width: width,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                            data.urlToImage
                                                                .toString(),
                                                          ),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                              )
                                              : const CircularProgressIndicator(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Text('${data.title}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
