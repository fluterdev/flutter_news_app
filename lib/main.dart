import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'news_fetch_cubit/counter_cubit.dart';
import 'news_fetch_cubit/news_fetch_cubit.dart';
import 'screens/counter_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsFetchCubit>(
          create: (context) => NewsFetchCubit(),
        ),
        BlocProvider<CounterCubit>(
          create: (context) => CounterCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CounterView(),
      ),
    );
  }
}
