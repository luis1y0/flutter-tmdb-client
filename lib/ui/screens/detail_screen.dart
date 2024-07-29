import 'package:flutter/material.dart';
import 'package:kueski_app/domain/entities/movie.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Column(
        children: [
          Text(widget.movie.originalTitle),
          Wrap(
            children: [
              const Text('Genres: '),
              for (var genre in widget.movie.genres)
                Chip(
                  label: Text(genre.name),
                ),
            ],
          ),
          Text(widget.movie.originalLanguage),
          Text(widget.movie.overview),
          Text(widget.movie.backdropPath),
          Text(widget.movie.posterPath),
          Text(widget.movie.popularity.toString()),
          Text(widget.movie.releaseDate.toString()),
          Text(widget.movie.voteAverage.toString()),
        ],
      ),
    );
  }
}
