import 'package:news_app/model/source_model.dart';

class NewsModel {
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String urlToImage;
  final String publishedAt;
  final String? content;
  final SourceModel? source;

  const NewsModel({
    this.author,
    required this.title,
    this.description,
    this.url,
    required this.urlToImage,
    required this.publishedAt,
    this.content,
    this.source,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      author: map['author'] ?? "",
      title: map['title'],
      description: map['description'] ?? "",
      url: map['url'] ?? "https://www.industry.gov.au/sites/default/files/August%202018/image/news-placeholder-738.png",
      urlToImage: map['urlToImage'] ?? "",
      publishedAt: map['publishedAt'],
      content: map['content'] ?? "",
      source: map['source'] != null ? SourceModel.fromMap(map['source']) : null,
    );
  }
}
