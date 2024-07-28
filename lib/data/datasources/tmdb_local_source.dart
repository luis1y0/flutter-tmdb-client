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
    List<Movie> favorites =
        results.map((el) => MovieModel.fromJson(el, genres)).toList();
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
      _database.delete('favorite', where: 'id = ?', whereArgs: [movie.id]);
    } else {
      _database.insert('favorite', movie.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
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
