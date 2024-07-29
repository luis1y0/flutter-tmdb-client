import 'package:flutter/material.dart';
import 'package:kueski_app/data/datasources/sqlitedb_singleton.dart';
import 'package:kueski_app/data/datasources/tmdb_api_source.dart';
import 'package:kueski_app/data/datasources/tmdb_local_source.dart';
import 'package:kueski_app/data/repositories/tmdb_repository.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/ui/blocs/pages_bloc.dart';
import 'package:kueski_app/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

late MoviesRepository moviesRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SqliteDbSingleton sqliteDbSingleton = SqliteDbSingleton.instance();
  await sqliteDbSingleton.initialize();
  TmdbMoviesSource tmdbMoviesSource = TmdbMoviesSource(http.Client());
  moviesRepository = TmdbMoviesRepository(
    SqliteMoviesSource(sqliteDbSingleton.database),
    tmdbMoviesSource,
  );
  tmdbMoviesSource.genres = await moviesRepository.getGenres();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
