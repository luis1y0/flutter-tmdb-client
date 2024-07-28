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

  SqliteMoviesSource(this._database) {
    //getDatabasesPath().then((path) =>
    //    openDatabase('$path/movies.db', onCreate: _onCreateDatabase)
    //        .then(_initDatabase));
  }

  FutureOr<void> _onCreateDatabase(Database db, int version) {
    db.execute('''CREATE TABLE genre (
    id INTEGER PRIMARY KEY NOT NULL,
    name TEXT NOT NULL
    )''');
    db.execute('''CREATE TABLE favorite (
      id INTEGER PRIMARY KEY NOT NULL,
      title TEXT NOT NULL,
      originalTitle TEXT NOT NULL,
      originalLanguage TEXT NOT NULL,
      overview TEXT NOT NULL,
      posterPath TEXT NOT NULL,
      backdropPath TEXT NOT NULL,
      releaseDate TEXT NOT NULL,
      isAdult TEXT NOT NULL,
      voteCount TEXT NOT NULL,
      voteAverage REAL NOT NULL,
      popularity REAL NOT NULL,
      genres TEXT NOT NULL
    )''');
  }

  void _initDatabase(Database db) {
    //_database = db;
  }

  @override
  Future<List<Movie>> getFavorites() async {
    List<Map<String, Object?>> results = await _database.query('favorite');
    List<Movie> favorites =
        results.map((el) => MovieModel.fromJson(el)).toList();
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
