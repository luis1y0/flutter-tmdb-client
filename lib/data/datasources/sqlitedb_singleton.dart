import 'dart:async';
import 'package:sqflite/sqflite.dart';

class SqliteDbSingleton {
  static SqliteDbSingleton? _instance;
  Database? _database;

  SqliteDbSingleton._internal();

  factory SqliteDbSingleton.instance() {
    _instance ??= SqliteDbSingleton._internal();
    return _instance!;
  }

  Database get database {
    if (_database == null) {
      throw Exception('First call initialize() method');
    }
    return _database!;
  }

  Future<void> initialize() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      '$path/movies.db',
      version: 1,
      onCreate: _onCreateDatabase,
    );
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
}
