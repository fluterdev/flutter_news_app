import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/screens/news_detail_page.dart';
import 'package:news_app/services/services.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<String> tabs = ['Apple', 'Tesla', 'Techcrunch'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter News'),
          centerTitle: true,
          bottom: TabBar(
            tabs: tabs
                .map(
                  (tab) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(tab),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    // setState(() {});
                  },
                );
              },
              child: SafeArea(
                child: FutureBuilder<List<NewsModel>?>(
                  future: tab == 'Techcrunch'
                      ? ApiServices.fetchAllNewsWithSource(source: tab.toLowerCase())
                      : ApiServices.fetchAllNews(
                          categoryName: tab.toLowerCase(),
                        ),
                  builder: (context, snapshot) {
                    final List<NewsModel>? newsModelList = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (newsModelList != null) {
                      return newsModelList.isEmpty
                          ? const Center(
                              child: Text('No News'),
                            )
                          : ListView.builder(
                              itemCount: newsModelList.length,
                              itemBuilder: (context, index) {
                                final NewsModel newsModel = newsModelList[index];
                                return _buildSingleTileNews(context, newsModel);
                              },
                            );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSingleTileNews(BuildContext context, NewsModel newsModel) {
    final format = DateFormat('MMM d, yyyy');
    final publishedDate = DateTime.parse(newsModel.publishedAt);
    final formattedString = format.format(publishedDate);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailPage(
              newsModel: newsModel,
              formattedDate: formattedString,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                newsModel.urlToImage,
                height: 100,
                width: 80,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsModel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    newsModel.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.today_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Text(
                            formattedString,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              newsModel.source?.name ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
