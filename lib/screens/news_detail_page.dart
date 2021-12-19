import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({
    Key? key,
    required this.newsModel,
    required this.formattedDate,
  }) : super(key: key);

  final NewsModel newsModel;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    newsModel.urlToImage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  newsModel.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        newsModel.author ?? "Unknown",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                 const SizedBox(height: 20),
                Text(
                  newsModel.content ?? "",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
