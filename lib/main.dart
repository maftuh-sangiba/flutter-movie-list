import 'package:flutter/material.dart';
import 'package:post_test/provider/movie_provider.dart';
import 'package:post_test/screen/movie_list_screen.dart';
import 'package:provider/provider.dart';
import 'screen/add_movie_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const MovieListScreen(),
          '/addMovie': (context) => const AddMovieScreen(),
        },
      ),
    );
  }
}
