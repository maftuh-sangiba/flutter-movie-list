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
  List<String>? genres;
  String? summary;
  Movie? movie;
  bool isEmptyGenres = false;

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
    'summary': 'Please enter a summary',
    'genres': 'Please select a genres',
  };

  @override
  void initState() {
    super.initState();
    genres = movie?.genres != null ? movie!.genres : [];
  }

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)!.settings.arguments as Movie?;

    if (movie?.genres != null) {
      genres = movie!.genres;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              movie == null ? Navigator.pop(context) : _deleteMovie(context);
            },
            icon: movie == null
                ? const Icon(Icons.close)
                : const Icon(Icons.delete_forever),
          ),
          IconButton(
            onPressed: () {
              _saveMovie(context);
            },
            icon: const Icon(Icons.check),
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
                  initialValue: movie?.title ?? '',
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: movie?.director ?? '',
                  decoration: InputDecoration(
                    labelText: 'Director',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: movie?.year.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: movie?.summary ?? '', // Set initial value
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Summary',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return errorMessages['summary'];
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      summary = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Genres:'),
                Wrap(
                  children: availableGenres.map((genre) {
                    final isSelected = genres!.contains(genre);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              genres!.remove(genre);
                            } else {
                              genres!.add(genre);
                              isEmptyGenres = false;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? ThemeData().primaryColor
                              : ThemeData().dialogBackgroundColor,
                          side: BorderSide(
                            color:
                                isEmptyGenres ? Colors.red : Colors.transparent,
                            width: 2.0, // Adjust border width as needed
                          ),
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            color: isSelected
                                ? ThemeData().indicatorColor
                                : isEmptyGenres
                                    ? Colors.red
                                    : ThemeData().unselectedWidgetColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
              summary: summary!,
              genres: genres!),
        );
      } else {
        id = movie?.id;
        title = title ?? movie?.title;
        director = director ?? movie?.director;
        year = year ?? movie?.year;
        summary = summary ?? movie?.summary;
        genres = genres ?? movie?.genres;

        movieProvider.editMovie(
          Movie(
              id: id!,
              title: title!,
              director: director!,
              year: year!,
              summary: summary!,
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
    if (summary == null || summary!.isEmpty) {
      errors.add(errorMessages['summary']!);
    }
    if (genres!.isEmpty) {
      errors.add(errorMessages['genres']!);
      setState(() {
        isEmptyGenres = true;
      });
    }
    if (errors.isNotEmpty) {
      return errors.join('\n');
    }

    return 'Please fill in all fields.';
  }
}
