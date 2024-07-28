import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kueski_app/data/models/movie.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/exceptions/exceptions.dart';

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
    var now = DateTime.now();
    var aMonthAgo = now.subtract(const Duration(days: 30));
    String year = aMonthAgo.year.toString();
    String month = aMonthAgo.month.toString().padLeft(2, '0');
    String day = aMonthAgo.day.toString().padLeft(2, '0');
    var minDate = '$year-$month-$day';
    year = now.year.toString();
    month = now.month.toString().padLeft(2, '0');
    day = now.day.toString().padLeft(2, '0');
    var maxDate = '$year-$month-$day';
    var uri = Uri.parse('$_apiUrl/discover/movie?include_adult=false'
        '&include_video=false&language=en-US&page=$page'
        '&sort_by=popularity.desc&with_release_type=2|3'
        '&release_date.gte=$minDate'
        '&release_date.lte=$maxDate'
        '&api_key=$_apiKey');
    return _fetchMovies(uri, page);
  }

  @override
  Future<List<Movie>> getPopularMovies(int page) async {
    var uri = Uri.parse('$_apiUrl/discover/movie?include_adult=false'
        '&include_video=false&language=en-US&page=$page'
        '&sort_by=popularity.desc&api_key=$_apiKey');
    return _fetchMovies(uri, page);
  }

  Future<List<Movie>> _fetchMovies(Uri url, int page) async {
    try {
      var response = await _client.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List jsonList = jsonResponse['results'];
        List<Movie> movies = [];
        for (Map<String, dynamic> item in jsonList) {
          movies.add(MovieModel.fromJson(item, []));
        }
        return movies;
      } else if (response.statusCode == 500) {
        throw ServiceException('Service unavailable, tray again later');
      } else if (response.statusCode == 404) {
        throw ServiceException('Movie information not available');
      } else {
        throw ServiceException('Service error, conctact support');
      }
    } on SocketException {
      throw ServiceException('Check you have stable network connection');
    } on ServiceException {
      rethrow;
    } catch (e) {
      throw ServiceException('Unexpected error, try again');
    }
  }
}
