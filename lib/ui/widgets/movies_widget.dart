import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/ui/blocs/type_view_bloc.dart';
import 'package:kueski_app/ui/widgets/movie_grid_widget.dart';
import 'package:kueski_app/ui/widgets/movie_list_widget.dart';

class MoviesWidget extends StatelessWidget {
  final String title;
  const MoviesWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
                    BlocProvider.of<TypeViewBloc>(
                      context,
                      listen: false,
                    ).switchListGrid();
                  },
                );
              },
            ),
          ],
        ),
        Expanded(
          child: BlocBuilder<TypeViewBloc, TypeViewState>(
            builder: (context, state) {
              if (state == TypeViewState.listView) {
                return const MovieListWidget();
              } else {
                return const MovieGridWidget();
              }
            },
          ),
        )
      ],
    );
  }
}
