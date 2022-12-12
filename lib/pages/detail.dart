import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  data[0]['image'] != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Hero(
                                                tag: '${data[0]['image']}',
                            child: Container(
                              width: width,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data[0]['image'].toString()),
                                    fit: BoxFit.fill
                                    ),
                              ),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                      children: [
                        Text('${data[0]['title']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 15),
                        Text('${data[0]['description']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[850])),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${data[0]['date']}'.substring(0, 10), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            Text('${data[0]['author']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ],
                  ),
                    ))
                ],
              ),
            ),
          ),
        ));
  }
}
