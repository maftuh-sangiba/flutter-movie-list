import 'package:flutter/material.dart';
import 'package:post_test/model/movie_model.dart';
import 'package:post_test/provider/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late TextEditingController _searchController;
  late List<Movie> filteredMovies;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    filteredMovies =
        List.of(movieProvider.movies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMovies(String query, List<Movie> movies) {
    setState(() {
      filteredMovies = movies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final movies = movieProvider.movies;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData().primaryColor,
        centerTitle: true,
        title: Text(
          "Movie List",
          style: TextStyle(
            color: ThemeData().cardColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              controller: _searchController,
              onChanged: (value) => _filterMovies(value, movies),
              decoration: InputDecoration(
                labelText: 'Search by title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.search),
                suffixIconConstraints: const BoxConstraints(minWidth: 50),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/addMovie',
                          arguments: filteredMovies[index]);
                    },
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredMovies[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${filteredMovies[index].director}, ${filteredMovies[index].year}',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  filteredMovies[index].genres.join(", "),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
