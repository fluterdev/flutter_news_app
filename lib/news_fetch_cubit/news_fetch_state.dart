part of 'news_fetch_cubit.dart';

abstract class NewsFetchState extends Equatable {
  const NewsFetchState();
  @override
  List<Object> get props => [];
}

class NewsFetchInitial extends NewsFetchState {}

class NewsFetchLoading extends NewsFetchState {}

class NewsFetchLoaded extends NewsFetchState {
  final List<NewsModel> newsModelList;

  const NewsFetchLoaded({
    required this.newsModelList,
  });

  @override
  List<Object> get props => [newsModelList];
}

class NewsFetchError extends NewsFetchState {
  final String error;

  const NewsFetchError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
