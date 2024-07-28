import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kueski_app/data/models/movie.dart';
import 'package:kueski_app/domain/entities/movie.dart';

abstract class RemoteMoviesSource {
  Future<List<Movie>> getPopularMovies(int page);
  Future<List<Movie>> getNowPlayingMovies(int page);
  Future<List<Genre>> getGenres();
}

class TmdbMoviesSource extends RemoteMoviesSource {
  final http.Client _client;
  late final String _apiKey;
  final String _apiUrl = 'https://api.themoviedb.org/3';

  TmdbMoviesSource(this._client) {
    _apiKey = Uri.encodeQueryComponent(const String.fromEnvironment('API_KEY'));
  }

  @override
  Future<List<Genre>> getGenres() async {
    var uri = Uri.parse('$_apiUrl/movie/list?language=en&api_key=$_apiKey');
    var response = await _client.get(uri);
    if (response.statusCode == 200) {
      //
    }
    Map<String, dynamic> json = jsonDecode(response.body);
    List genresJson = json['genres'];
    List<Genre> genres = [];
    for (Map<String, dynamic> genreJson in genresJson) {
      genres.add(GenreModel.fromJson(genreJson));
    }
    return genres;
  }

  @override
  Future<List<Movie>> getNowPlayingMovies(int page) async {
    var uri = Uri.parse('$_apiUrl/discover/movie?include_adult=false'
        '&include_video=false&language=en-US&page=$page'
        '&sort_by=popularity.desc&api_key=$_apiKey');
    var response = await _client.get(uri);
    if (response.statusCode == 200) {
      //
    }
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> getPopularMovies(int page) async {
    var now = DateTime.now();
    var aYearAgo = now.subtract(const Duration(days: 365));
    var minDate = '2024-01-21';
    var maxDate = '2024-01-21';
    var uri = Uri.parse('$_apiUrl/discover/movie?include_adult=false'
        '&include_video=false&language=en-US&page=$page'
        '&sort_by=popularity.desc&with_release_type=2|3'
        '&release_date.gte=$minDate'
        '&release_date.lte=$maxDate'
        '&api_key=$_apiKey');
    var response = await _client.get(uri);
    if (response.statusCode == 200) {
      //
    }
    throw UnimplementedError();
  }
}
