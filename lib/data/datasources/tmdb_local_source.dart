import 'package:kueski_app/domain/entities/movie.dart';

abstract class LocalMoviesSource {
  Future<List<Genre>> setGenres(List<Genre> genres);
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getFavorites();
  Future<List<Movie>> setFavorite(Movie movie, bool isFavorite);
}

class SqliteMoviesSource extends LocalMoviesSource {
  @override
  Future<List<Movie>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<List<Genre>> getGenres() {
    // TODO: implement getGenres
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> setFavorite(Movie movie, bool isFavorite) {
    // TODO: implement setFavorite
    throw UnimplementedError();
  }

  @override
  Future<List<Genre>> setGenres(List<Genre> genres) {
    // TODO: implement setGenres
    throw UnimplementedError();
  }
}
