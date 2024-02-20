import 'package:flutter/material.dart';
import 'package:post_test/provider/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final movies = movieProvider.movies;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData().primaryColor,
        title: Text(
          "Movie List",
          style: TextStyle(
            color: ThemeData().cardColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4, // Add elevation for a card-like appearance
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/addMovie', arguments: movies[index]);
              },
              child: ListTile(
                title: Text(movies[index].title),
                subtitle:
                    Text('${movies[index].director}, ${movies[index].year}'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addMovie');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
