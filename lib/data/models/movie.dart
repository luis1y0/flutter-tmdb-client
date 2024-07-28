import 'package:kueski_app/domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.id,
    required super.title,
    required super.originalTitle,
    required super.originalLanguage,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.releaseDate,
    required super.isAdult,
    required super.voteCount,
    required super.voteAverage,
    required super.popularity,
    required super.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      originalTitle: json['originalTitle'],
      originalLanguage: json['originalLanguage'],
      overview: json['overview'],
      posterPath: json['posterPath'],
      backdropPath: json['backdropPath'],
      releaseDate: json['releaseDate'],
      isAdult: json['isAdult'],
      voteCount: json['voteCount'],
      voteAverage: json['voteAverage'],
      popularity: json['popularity'],
      genres:
          (json['genres'] as List).map((g) => GenreModel.fromJson(g)).toList(),
    );
  }
}

class GenreModel extends Genre {
  GenreModel({required super.id, required super.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'], name: json['name']);
  }
}
