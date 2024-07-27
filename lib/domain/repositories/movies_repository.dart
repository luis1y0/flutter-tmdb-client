import 'package:kueski_app/domain/entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getPopularMovies(int page);
  Future<List<Movie>> getNowPlayingMovies(int page);
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getFavorites();
  Future<List<Movie>> setFavorite(Movie movie, bool isFavorite);
}
