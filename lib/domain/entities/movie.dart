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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'original-title': originalTitle,
      'original-language': originalLanguage,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'releaseDate': releaseDate,
      'adult': isAdult,
      'voteCount': voteCount,
      'voteAverage': voteAverage,
      'popularity': popularity,
      'genres': genres.map((m) => m.id).toList().toString(),
    };
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Genre($id, $name)';
  }
}
