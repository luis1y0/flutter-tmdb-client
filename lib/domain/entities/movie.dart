class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final DateTime releaseDate;
  final bool isAdult;
  final int voteCount;
  final double voteAverage;
  final double popularity;
  final List<Genre> genres;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.isAdult,
    required this.voteCount,
    required this.voteAverage,
    required this.popularity,
    required this.genres,
  });
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });
}
