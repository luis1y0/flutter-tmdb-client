import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/exceptions/exceptions.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/data/datasources/tmdb_api_source.dart';
import 'package:kueski_app/data/datasources/tmdb_local_source.dart';
import 'package:kueski_app/data/repositories/tmdb_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockLocalMoviesSource extends Mock implements LocalMoviesSource {}

class MockRemoteMoviesSource extends Mock implements RemoteMoviesSource {}

class MockSqliteMoviesSource extends Mock implements SqliteMoviesSource {}

class MockDatabase extends Mock implements Database {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('Genre', () {
    late List<Genre> testGenres;
    late LocalMoviesSource mockLocalMoviesSource;
    late RemoteMoviesSource mockRemoteMoviesSource;
    late SqliteMoviesSource mockSqliteMoviesSource;
    late Database mockDatabase;
    late http.Client mockHttpClient;
    late String genreBody;
    setUp(() {
      mockHttpClient = MockHttpClient();
      mockDatabase = MockDatabase();
      mockSqliteMoviesSource = MockSqliteMoviesSource();
      mockRemoteMoviesSource = MockRemoteMoviesSource();
      mockLocalMoviesSource = MockLocalMoviesSource();
      testGenres = [
        Genre(id: 28, name: 'Action'),
        Genre(id: 12, name: 'Abenteuer'),
        Genre(id: 16, name: 'Animation'),
        Genre(id: 35, name: 'Komödie'),
      ];
      when(() => mockLocalMoviesSource.getGenres()).thenAnswer(
        (_) async => testGenres,
      );
      when(
        () => mockDatabase.query(any()),
      ).thenAnswer((_) async => []);
      File genreFile = File('./test/genres.json');
      genreBody = genreFile.readAsStringSync();
      registerFallbackValue(Uri());
    });
    test('Get Genres first from Local', () async {
      MoviesRepository moviesRep =
          TmdbMoviesRepository(mockLocalMoviesSource, mockRemoteMoviesSource);
      var genres = await moviesRep.getGenres();
      expect(genres.length, testGenres.length);
      expect(genres.first.id, testGenres.first.id);
    });
    test('EmptyCacheException when empty genre cache', () async {
      LocalMoviesSource localMoviesSource = SqliteMoviesSource(mockDatabase);
      expect(
          localMoviesSource.getGenres(), throwsA(isA<EmptyCacheException>()));
    });
    test('Get Genres from API when empty cache', () async {
      when(
        () => mockDatabase.delete(any()),
      ).thenAnswer((_) async => 0);
      when(
        () => mockDatabase.insert(any(), any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm')),
      ).thenAnswer((Invocation invocation) async => 0);
      when(
        () => mockHttpClient.get(any<Uri>()),
      ).thenAnswer((_) async => http.Response(genreBody, 200));
      MoviesRepository repository = TmdbMoviesRepository(
          SqliteMoviesSource(mockDatabase), TmdbMoviesSource(mockHttpClient));
      List<Genre> genres = await repository.getGenres();
      expect(19, genres.length,
          reason: 'Genres are not read from test/genres.json file');
    });
  });
  group('Movies', () {
    //
  });
  group('Favorites', () {
    //
  });
}
