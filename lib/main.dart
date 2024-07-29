import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/data/datasources/sqlitedb_singleton.dart';
import 'package:kueski_app/data/datasources/tmdb_api_source.dart';
import 'package:kueski_app/data/datasources/tmdb_local_source.dart';
import 'package:kueski_app/data/repositories/tmdb_repository.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/ui/blocs/favorites_bloc.dart';
import 'package:kueski_app/ui/blocs/pages_bloc.dart';
import 'package:kueski_app/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SqliteDbSingleton sqliteDbSingleton = SqliteDbSingleton.instance();
  await sqliteDbSingleton.initialize();
  TmdbMoviesSource tmdbMoviesSource = TmdbMoviesSource(http.Client());
  MoviesRepository moviesRepository = TmdbMoviesRepository(
    SqliteMoviesSource(sqliteDbSingleton.database),
    tmdbMoviesSource,
  );
  tmdbMoviesSource.genres = await moviesRepository.getGenres();
  runApp(Application(
    moviesRepository: moviesRepository,
  ));
}

class Application extends StatelessWidget {
  final MoviesRepository moviesRepository;
  const Application({super.key, required this.moviesRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesBloc>(
      // this way is available in widget tree where to AppBar
      create: (_) => FavoritesBloc(moviesRepository),
      child: MaterialApp(
        title: 'KueskiApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiProvider(
          providers: [
            Provider<PagesBloc>(create: (_) => PagesBloc()),
            Provider<MoviesRepository>(
              create: (_) => moviesRepository,
            ),
          ],
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
