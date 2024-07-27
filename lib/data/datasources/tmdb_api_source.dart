import 'package:kueski_app/domain/entities/movie.dart';

abstract class RemoteMoviesSource {
  Future<List<Movie>> getPopularMovies(int page);
  Future<List<Movie>> getNowPlayingMovies(int page);
  Future<List<Genre>> getGenres();
}

class TmdbMoviesSource extends RemoteMoviesSource {
  @override
  Future<List<Genre>> getGenres() {
    // TODO: implement getGenres
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> getNowPlayingMovies(int page) {
    // TODO: implement getNoPlayingMovies
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> getPopularMovies(int page) {
    // TODO: implement getPopularMovies
    throw UnimplementedError();
  }
}
