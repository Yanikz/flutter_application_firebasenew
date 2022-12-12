import 'package:dio/dio.dart';
import '../models/model.dart';

Future<List<Article>?> fetchAlbum() async {
  var dio = Dio();
  var url = 'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=03cd77e9250c4599beb56603c339d105&language=en';
    try {
      Response response = await dio.get(url);
      NewsResponse newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse.articles;
    // ignore: empty_catches
    } on DioError {}
    return null;
  }