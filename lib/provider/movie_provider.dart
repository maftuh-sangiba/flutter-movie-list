import 'package:flutter/material.dart';
import 'package:post_test/data/movie_data.dart';
import 'package:post_test/model/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  MovieProvider() {
    _movies = moviesData;
  }

  void addMovie(Movie movie) {
    _movies.add(movie);
    notifyListeners();
  }

  void editMovie(Movie updatedMovie) {
    int index = _movies.indexWhere((movie) => movie.id == updatedMovie.id);

    if (index != -1) {
      _movies[index] = updatedMovie;
      notifyListeners();
    }
  }

  void deleteMovie(int id) {
    _movies.removeWhere((movie) => movie.id == id);
    notifyListeners();
  }
}
