import 'dart:convert';

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

  factory MovieModel.fromJson(
      Map<String, dynamic> json, List<Genre> defaultGenres) {
    String releaseDateVal = json['release_date']; // yyyy-mm-dd
    var releaseDate = DateTime.parse(releaseDateVal);
    return MovieModel(
      id: json['id'],
      title: json['title'],
      originalTitle: json['original_title'],
      originalLanguage: json['original_language'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: releaseDate,
      isAdult: json['adult'],
      voteCount: json['vote_count'],
      voteAverage: json['vote_average'],
      popularity: json['popularity'],
      genres: (json['genre_ids'] as List)
          .map((id) => defaultGenres.firstWhere((dg) => dg.id == id))
          .toList(),
    );
  }

  factory MovieModel.fromLocalJson(
      Map<String, dynamic> json, List<Genre> defaultGenres) {
    String genresText = json['genre_ids'];
    List genreIds = jsonDecode(genresText);
    json['genre_ids'] = genreIds;
    return MovieModel.fromJson(json, defaultGenres);
  }
}

class GenreModel extends Genre {
  GenreModel({required super.id, required super.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'], name: json['name']);
  }
}
