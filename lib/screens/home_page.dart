import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/news_fetch_cubit/news_fetch_cubit.dart';
import 'package:news_app/screens/news_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    //initially fetching apple news
    BlocProvider.of<NewsFetchCubit>(context).getNewsListFromApi(categoryName: 'apple');

    //initializing the tab controller
    _controller = TabController(length: tabs.length, vsync: this);

    //listening tabs on scroll and fetching news based on tabs
    _controller.addListener(() {
      if (_controller.index == 0) {
        BlocProvider.of<NewsFetchCubit>(context).getNewsListFromApi(categoryName: 'apple');
      } else if (_controller.index == 1) {
        BlocProvider.of<NewsFetchCubit>(context).getNewsListFromApi(categoryName: 'tesla');
      }
    });
  }

  final List<String> tabs = ['Apple', 'Tesla'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter News'),
          centerTitle: true,
          bottom: TabBar(
            controller: _controller,
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<NewsFetchCubit>(context).getNewsListFromApi(categoryName: 'apple');
              } else if (index == 1) {
                BlocProvider.of<NewsFetchCubit>(context).getNewsListFromApi(categoryName: 'tesla');
              }
            },
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
          // physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: tabs.map((tab) {
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    BlocProvider.of<NewsFetchCubit>(context).getNewsListFromApi(categoryName: tab.toLowerCase());
                  },
                );
              },
              child: BlocBuilder<NewsFetchCubit, NewsFetchState>(
                builder: (context, newsFetchState) {
                  if (newsFetchState is NewsFetchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (newsFetchState is NewsFetchError) {
                    return Center(
                      child: Text(newsFetchState.error),
                    );
                  } else if (newsFetchState is NewsFetchLoaded) {
                    final List<NewsModel> newsList = newsFetchState.newsModelList;
                    return newsList.isEmpty
                        ? const Center(
                            child: Text('No news'),
                          )
                        : ListView.builder(
                            itemCount: newsList.length,
                            itemBuilder: (context, index) {
                              final NewsModel newsModel = newsList[index];
                              return _buildSingleTileNews(context, newsModel);
                            },
                          );
                  }

                  return const SizedBox.shrink();
                },
              ),
              // child: SafeArea(
              //   child: FutureBuilder<List<NewsModel>?>(
              //     future: tab == 'Techcrunch'
              //         ? ApiServices.fetchAllNewsWithSource(source: tab.toLowerCase())
              //         : ApiServices.fetchAllNews(
              //             categoryName: tab.toLowerCase(),
              //           ),
              //     builder: (context, snapshot) {
              //       final List<NewsModel>? newsModelList = snapshot.data;
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //       if (newsModelList != null) {
              //         return newsModelList.isEmpty
              //             ? const Center(
              //                 child: Text('No News'),
              //               )
              //             : ListView.builder(
              //                 itemCount: newsModelList.length,
              //                 itemBuilder: (context, index) {
              //                   final NewsModel newsModel = newsModelList[index];
              //                   return _buildSingleTileNews(context, newsModel);
              //                 },
              //               );
              //       }
              //       return const SizedBox.shrink();
              //     },
              //   ),
              // ),
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
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const SizedBox(
                    height: 100,
                    width: 80,
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
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
                      Flexible(
                        child: Row(
                          children: [
                            Text(
                              formattedString,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Container(
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
                            ),
                          ],
                        ),
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
