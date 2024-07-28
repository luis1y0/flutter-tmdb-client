import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kueski_app/data/models/movie.dart';
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
  late List<Genre> defaultGenres;
  setUp(() {
    defaultGenres = [
      Genre(id: 28, name: 'Action'),
      Genre(id: 12, name: 'Abenteuer'),
      Genre(id: 16, name: 'Animation'),
      Genre(id: 35, name: 'Komödie'),
      Genre(id: 80, name: 'Krimi'),
      Genre(id: 99, name: 'Dokumentarfilm'),
      Genre(id: 18, name: 'Drama'),
      Genre(id: 10751, name: 'Familie'),
      Genre(id: 14, name: 'Fantasy'),
      Genre(id: 36, name: 'Historie'),
      Genre(id: 27, name: 'Horror'),
      Genre(id: 10402, name: 'Musik'),
      Genre(id: 9648, name: 'Mystery'),
      Genre(id: 10749, name: 'Liebesfilm'),
      Genre(id: 878, name: 'Science Fiction'),
      Genre(id: 10770, name: 'TV-Film'),
      Genre(id: 53, name: 'Thriller'),
      Genre(id: 10752, name: 'Kriegsfilm'),
      Genre(id: 37, name: 'Western')
    ];
  });
  group('Genre', () {
    late List<Genre> testGenres;
    late LocalMoviesSource mockLocalMoviesSource;
    late RemoteMoviesSource mockRemoteMoviesSource;
    late Database mockDatabase;
    late http.Client mockHttpClient;
    late String genreBody;
    setUp(() {
      mockHttpClient = MockHttpClient();
      mockDatabase = MockDatabase();
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
    late String textMovies;
    late String textMovie;
    late TmdbMoviesSource tmdbMoviesSource;
    late MockHttpClient mockHttpClient;
    setUp(() {
      mockHttpClient = MockHttpClient();
      tmdbMoviesSource = TmdbMoviesSource(mockHttpClient);
      textMovie = '{"adult": false,"backdrop_path": '
          '"/xg27NrXi7VXCGUr7MG75UqLl6Vg.jpg","genre_ids": [16,10751,12,35],"id":'
          '1022789,"original_language": "en","original_title": "Inside Out 2",'
          '"overview": "Teenager Riley\'s mind headquarters is undergoing a sudden '
          'demolition to make room for something entirely unexpected: new Emotions!'
          ' Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a '
          'successful operation by all accounts, aren’t sure how to feel when '
          'Anxiety shows up. And it looks like she’s not alone.","popularity": '
          '4645.667,"poster_path": "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg",'
          '"release_date": "2024-06-11","title": "Inside Out 2","video": '
          'false,"vote_average": 7.64,"vote_count": 2069}';
      File fileMovies = File('./test/popular_movies.json');
      textMovies = fileMovies.readAsStringSync();
      registerFallbackValue(Uri());
    });
    test('Generate properly movie properties from JSON', () {
      Map<String, dynamic> json = jsonDecode(textMovie);
      expect(() => MovieModel.fromJson(json, defaultGenres), returnsNormally);
      var movie = MovieModel.fromJson(json, defaultGenres);
      expect(movie.originalTitle, 'Inside Out 2');
      expect(movie.releaseDate, DateTime(2024, 6, 11));
      expect(movie.genres.map((el) => el.id).toList(), [16, 10751, 12, 35]);
    });
    test('Movie instance is parsed back and forth from local storage', () {
      Map<String, dynamic> json1 = jsonDecode(textMovie);
      var movie1 = MovieModel.fromJson(json1, defaultGenres);
      Map<String, dynamic> localJson = movie1.toMap();
      var movie2 = MovieModel.fromLocalJson(localJson, defaultGenres);
      expect(movie1, movie2);
      expect(movie1.genres, movie2.genres);
      expect(movie1.releaseDate, movie2.releaseDate);
    });
    test('ServiceException when http code is not 200', () {
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      expect(() => tmdbMoviesSource.getPopularMovies(1),
          throwsA(isA<ServiceException>()));
    });
    test('Exception when an unknown error happened', () {
      when(() => mockHttpClient.get(any())).thenThrow(Exception());
      expectLater(() => tmdbMoviesSource.getPopularMovies(1),
          throwsA(isA<ServiceException>()));
    });
    test('Movie list parsed correctly', () async {
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response(textMovies, 200));
      List<Movie> movies = await tmdbMoviesSource.getPopularMovies(1);
      expect(movies.length, 20);
      expect(movies.first.title, 'Inside Out 2');
    });
  });
}
