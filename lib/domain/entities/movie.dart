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
    String year = releaseDate.year.toString();
    String month = releaseDate.month.toString().padLeft(2, '0');
    String day = releaseDate.day.toString().padLeft(2, '0');
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'original_language': originalLanguage,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': '$year-$month-$day',
      'adult': isAdult,
      'vote_count': voteCount,
      'vote_average': voteAverage,
      'popularity': popularity,
      'genre_ids': genres.map((m) => m.id).toList().toString(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
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

  @override
  bool operator ==(Object other) {
    return other is Genre && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
