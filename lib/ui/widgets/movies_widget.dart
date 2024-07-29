import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/ui/blocs/type_view_bloc.dart';
import 'package:kueski_app/ui/screens/detail_screen.dart';
import 'package:provider/provider.dart';

class MoviesWidget extends StatelessWidget {
  final String title;
  const MoviesWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var typeViewBloc = TypeViewBloc();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            BlocBuilder<TypeViewBloc, TypeViewState>(
              bloc: typeViewBloc,
              builder: (context, state) {
                IconData icon;
                if (state == TypeViewState.listView) {
                  icon = Icons.grid_view_sharp;
                } else {
                  icon = Icons.line_weight_sharp;
                }
                return IconButton(
                  icon: Icon(icon),
                  onPressed: () {
                    typeViewBloc.switchListGrid();
                  },
                );
              },
            ),
          ],
        ),
        Expanded(
          child: BlocBuilder<TypeViewBloc, TypeViewState>(
            bloc: typeViewBloc,
            builder: (context, state) {
              if (state == TypeViewState.listView) {
                return FutureBuilder<List<Movie>>(
                  future: Provider.of<MoviesRepository>(context)
                      .getNowPlayingMovies(1),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<Movie> movies = snapshot.data!;
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(movies[index].title),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailScreen(movie: movies[index]),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item ${index + 1}'),
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }
}
