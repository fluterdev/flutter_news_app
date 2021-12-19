import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/model/news_model.dart';

class ApiServices {
  static final Dio _dio = Dio();
  static Future<List<NewsModel>?> fetchAllNews({required String categoryName}) async {
    final String url = "https://newsapi.org/v2/everything?q=$categoryName&sortBy=popularity&apiKey=${Config.apiKey}";
    try {
      final Response response = await _dio.get(url);
      final data = response.data['articles'] as List<dynamic>;
      final List<NewsModel> newsListModel = data.map((newsModel) => NewsModel.fromMap(newsModel)).toList();
      return newsListModel;
    } catch (err) {
      debugPrint("Error during fetching news data :$err");
    }
  }
}
