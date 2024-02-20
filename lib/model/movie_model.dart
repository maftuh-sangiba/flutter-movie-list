class Movie {
  late int id;
  late String title;
  late String director;
  late int year;
  late String summary;
  late List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.year,
    required this.summary,
    required this.genres,
  });
}
