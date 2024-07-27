import 'package:flutter_test/flutter_test.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/data/datasources/tmdb_api_source.dart';
import 'package:kueski_app/data/datasources/tmdb_local_source.dart';
import 'package:kueski_app/data/repositories/tmdb_repository.dart';

void main() {
  late MoviesRepository moviesRepository;
  late LocalMoviesSource localMoviesSource;
  late RemoteMoviesSource remoteMoviesSource;

  List<Genre> testGenres = [
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
  setUp(() {
    localMoviesSource = SqliteMoviesSource();
    remoteMoviesSource = TmdbMoviesSource();
    moviesRepository = TmdbMoviesRepository(
      localMoviesSource,
      remoteMoviesSource,
    );
  });
  group('Genre', () {
    test('Get Genres', () async {
      var genres = await moviesRepository.getGenres();
      expect(genres, testGenres);
    });
  });
}
