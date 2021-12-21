import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/services/services.dart';

part 'news_fetch_state.dart';

class NewsFetchCubit extends Cubit<NewsFetchState> {
  NewsFetchCubit() : super(NewsFetchInitial());

  void getNewsListFromApi({required String categoryName}) async {
    if (state is! NewsFetchLoaded) {
      emit(NewsFetchLoading());
    }
    try {
      final List<NewsModel>? newsModelList = await ApiServices.fetchAllNews(categoryName: categoryName);
      emit(NewsFetchLoaded(newsModelList: newsModelList ?? []));
    } catch (err) {
      emit(NewsFetchError(error: err.toString()));

      debugPrint("Error during fetching news in cubit :$err");
    }
  }
}
