// lib/Services/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final String publishedAt; 
  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url, 
    required this.publishedAt, 
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '', // ✅
      publishedAt: json['publishedAt'] ?? '', 
    );
  }
}

class NewsService {
  final String _apiKey = 'c05765431aac47ae9840bb7f68f19ebc';

  Future<List<NewsArticle>> fetchNews() async {
    final response = await http.get(
      Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];

      return articles
          .map((articleJson) => NewsArticle.fromJson(articleJson))
          .toList();
    } else {
      throw Exception('No News Found');
    }
  }
}
