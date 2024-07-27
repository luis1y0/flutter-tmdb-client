import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/data/datasources/tmdb_api_source.dart';
import 'package:kueski_app/data/datasources/tmdb_local_source.dart';

class TmdbMoviesRepository extends MoviesRepository {
  final LocalMoviesSource _localMoviesSource;
  final RemoteMoviesSource _remoteMoviesSource;

  TmdbMoviesRepository(this._localMoviesSource, this._remoteMoviesSource);

  @override
  Future<List<Genre>> getGenres() async {
    try {
      return _localMoviesSource.getGenres();
    } catch (_) {
      List<Genre> genres = await _remoteMoviesSource.getGenres();
      _localMoviesSource.setGenres(genres);
      return genres;
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies(int page) {
    return _remoteMoviesSource.getNowPlayingMovies(page);
  }

  @override
  Future<List<Movie>> getPopularMovies(int page) {
    return _remoteMoviesSource.getPopularMovies(page);
  }

  @override
  Future<List<Movie>> getFavorites() {
    return _localMoviesSource.getFavorites();
  }

  @override
  Future<List<Movie>> setFavorite(Movie movie, bool isFavorite) {
    return _localMoviesSource.setFavorite(movie, isFavorite);
  }
}
