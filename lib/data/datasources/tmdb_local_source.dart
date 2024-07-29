import 'dart:async';

import 'package:kueski_app/data/models/movie.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/exceptions/exceptions.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalMoviesSource {
  Future<List<Genre>> setGenres(List<Genre> genres);
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getFavorites();
  Future<List<Movie>> setFavorite(Movie movie, bool isFavorite);
}

class SqliteMoviesSource extends LocalMoviesSource {
  final Database _database;

  SqliteMoviesSource(this._database);

  @override
  Future<List<Movie>> getFavorites() async {
    List<Map<String, Object?>> results = await _database.query('favorite');
    List<Genre> genres = await getGenres();
    List<Movie> favorites = [];
    for (Map<String, Object?> item in results) {
      Map<String, dynamic> values = {
        'id': item['id'],
        'title': item['title'],
        'original_title': item['originalTitle'],
        'original_language': item['originalLanguage'],
        'overview': item['overview'],
        'poster_path': item['posterPath'],
        'backdrop_path': item['backdropPath'],
        'release_date': item['releaseDate'],
        'adult': bool.parse(item['isAdult'].toString()),
        'vote_count': item['voteCount'],
        'vote_average': item['voteAverage'],
        'popularity': item['popularity'],
        'genre_ids': item['genres'],
      };
      favorites.add(MovieModel.fromLocalJson(values, genres));
    }
    return favorites;
  }

  @override
  Future<List<Genre>> getGenres() async {
    List<Map<String, Object?>> results = await _database.query('genre');
    if (results.isEmpty) {
      throw EmptyCacheException();
    }
    List<Genre> genres = results.map((el) => GenreModel.fromJson(el)).toList();
    return genres;
  }

  @override
  Future<List<Movie>> setFavorite(Movie movie, bool isFavorite) {
    if (isFavorite) {
      String year = movie.releaseDate.year.toString();
      String month = movie.releaseDate.month.toString().padLeft(2, '0');
      String day = movie.releaseDate.day.toString().padLeft(2, '0');
      Map<String, dynamic> values = {
        'id': movie.id,
        'title': movie.title,
        'originalTitle': movie.originalTitle,
        'originalLanguage': movie.originalLanguage,
        'overview': movie.overview,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'releaseDate': '$year-$month-$day',
        'isAdult': movie.isAdult.toString(),
        'voteCount': movie.voteCount,
        'voteAverage': movie.voteAverage,
        'popularity': movie.popularity,
        'genres': movie.genres.map((el) => el.id).toList().toString(),
      };
      _database.insert(
        'favorite',
        values,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      _database.delete('favorite', where: 'id = ?', whereArgs: [movie.id]);
    }
    return getFavorites();
  }

  @override
  Future<List<Genre>> setGenres(List<Genre> genres) async {
    _database.delete('genre');
    for (var genre in genres) {
      _database.insert('genre', genre.toMap());
    }
    return genres;
  }
}
