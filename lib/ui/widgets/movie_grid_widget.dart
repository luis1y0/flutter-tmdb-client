import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/ui/blocs/pagination_view/pagination_view_bloc.dart';
import 'package:kueski_app/ui/screens/detail_screen.dart';

class MovieGridWidget extends StatelessWidget {
  const MovieGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var paginationBloc = BlocProvider.of<PaginationViewBloc>(
      context,
      listen: false,
    );
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        double total = notification.metrics.maxScrollExtent;
        double position = notification.metrics.pixels;
        paginationBloc.scrollPosition = position;
        if (total - position < 10) {
          paginationBloc.add(NearPageEndEvent());
        }
        return true;
      },
      child: BlocBuilder<PaginationViewBloc, PaginationState>(
        builder: (context, state) {
          return GridView.builder(
            controller: ScrollController(
              initialScrollOffset: paginationBloc.scrollPosition,
            ),
            itemCount: state.movies.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              if (index == state.movies.length) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text(state.movies[index].title),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(movie: state.movies[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
