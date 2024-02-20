import 'package:flutter/material.dart';
import 'package:post_test/model/movie_model.dart';
import 'package:post_test/provider/movie_provider.dart';
import 'package:provider/provider.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  int? id;
  String? title;
  String? director;
  int? year;
  List<String>? genres = [];
  Movie? movie;

  List<String> availableGenres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'Western',
  ];

  Map<String, String> errorMessages = {
    'title': 'Please enter a title',
    'director': 'Please enter a director',
    'year': 'Please enter a year',
  };

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)!.settings.arguments as Movie?;
    genres = movie?.genres ?? [];

    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ThemeData().canvasColor),
        backgroundColor: ThemeData().primaryColor,
        title: Text(
          movie == null ? "Add Movie" : "Edit Movie",
          style: TextStyle(color: ThemeData().cardColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _deleteMovie(context); // Discard the changes
            },
            icon: const Icon(Icons.close), // Add a Close icon for Discard
          ),
          IconButton(
            onPressed: () {
              _saveMovie(context); // Save the movie
            },
            icon: const Icon(Icons.check), // Add a Check icon for Save
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: movie?.title ?? '', // Set initial value
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return errorMessages['title'];
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: movie?.director ?? '', // Set initial value
                  decoration: const InputDecoration(labelText: 'Director'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return errorMessages['director'];
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      director = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: movie?.year.toString() ?? '', // Set initial value
                  decoration: const InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return errorMessages['year'];
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      year = int.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Genres:'),
                Wrap(
                  children: availableGenres
                      .map(
                        (genre) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (genres!.contains(genre)) {
                                  genres!.remove(genre);
                                } else {
                                  genres!.add(genre);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: genres!.contains(genre)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            child: Text(genre),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveMovie(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (movie == null) {
        final movieProvider =
            Provider.of<MovieProvider>(context, listen: false);
        id = movie?.id == null ? movieProvider.movies.last.id + 1 : 1;

        movieProvider.addMovie(
          Movie(
              id: id!,
              title: title!,
              director: director!,
              year: year!,
              genres: genres!),
        );
      } else {
        id = movie?.id;
        title = title ?? movie?.title;
        director = director ?? movie?.director;
        year = year ?? movie?.year;
        genres = genres ?? movie?.genres;

        movieProvider.editMovie(
          Movie(
              id: id!,
              title: title!,
              director: director!,
              year: year!,
              genres: genres!),
        );
      }
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(getErrorMessage()),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _deleteMovie(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    movieProvider.deleteMovie(
      movie!.id,
    );

    Navigator.pop(context);
  }

  String getErrorMessage() {
    List<String> errors = [];

    if (title == null || title!.isEmpty) {
      errors.add(errorMessages['title']!);
    }
    if (director == null || director!.isEmpty) {
      errors.add(errorMessages['director']!);
    }
    if (year == null || year == 0) {
      errors.add(errorMessages['year']!);
    }

    if (errors.isNotEmpty) {
      return errors.join('\n');
    }

    return 'Please fill in all fields.';
  }
}
